import Foundation
import SwiftData

/// Wraps SwiftData access for the two pieces of state that persist across sessions: high
/// score / per-mode performance, and which (mode, country) questions have already been
/// asked. Kept separate from `QuizSession` so the in-round scoring logic stays a pure,
/// SwiftData-free unit (see `QuizSessionTests`) — this is the only place that touches
/// `ModelContext`.
@MainActor
struct GameStatsStore {
    let context: ModelContext

    // MARK: - Asked-question history

    /// Countries already asked per mode, in the current cycle. If a mode's asked set
    /// already covers every country, that mode's history is cleared first — once you've
    /// been asked everything, the next round starts a fresh cycle — so the caller sees an
    /// empty set for it.
    func excludedCountryIDs(totalCountryCount: Int) -> [GameMode: Set<String>] {
        var result: [GameMode: Set<String>] = [:]
        for mode in GameMode.allCases {
            let records = askedRecords(for: mode)
            if records.count >= totalCountryCount {
                records.forEach { context.delete($0) }
                result[mode] = []
            } else {
                result[mode] = Set(records.map(\.countryID))
            }
        }
        try? context.save()
        return result
    }

    /// Marks the given countries as asked for each mode, skipping ones already recorded.
    func recordAsked(_ countryIDsByMode: [GameMode: [String]]) {
        for (mode, countryIDs) in countryIDsByMode {
            let existing = Set(askedRecords(for: mode).map(\.countryID))
            for countryID in countryIDs where !existing.contains(countryID) {
                context.insert(AskedQuestionRecord(mode: mode, countryID: countryID))
            }
        }
        try? context.save()
    }

    private func askedRecords(for mode: GameMode) -> [AskedQuestionRecord] {
        let raw = mode.rawValue
        let descriptor = FetchDescriptor<AskedQuestionRecord>(
            predicate: #Predicate { $0.modeRawValue == raw }
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - Highscore / strongest category

    var bestScore: Int {
        fetchOrCreateHighScore().bestScore
    }

    /// Updates the high score (if beaten) and folds this round's per-mode results into the
    /// running totals used by `ModeStatRecord.strongestCategory`. Call exactly once per
    /// finished round.
    func recordRoundResult(totalScore: Int, perModePoints: [GameMode: (points: Int, count: Int)]) {
        let highScore = fetchOrCreateHighScore()
        if totalScore > highScore.bestScore {
            highScore.bestScore = totalScore
        }
        for (mode, tally) in perModePoints {
            let stat = fetchOrCreateModeStat(mode)
            stat.totalPointsEarned += tally.points
            stat.questionsAnswered += tally.count
        }
        try? context.save()
    }

    private func fetchOrCreateHighScore() -> HighScoreRecord {
        let descriptor = FetchDescriptor<HighScoreRecord>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        let created = HighScoreRecord()
        context.insert(created)
        return created
    }

    private func fetchOrCreateModeStat(_ mode: GameMode) -> ModeStatRecord {
        let raw = mode.rawValue
        let descriptor = FetchDescriptor<ModeStatRecord>(predicate: #Predicate { $0.modeRawValue == raw })
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        let created = ModeStatRecord(mode: mode)
        context.insert(created)
        return created
    }
}
