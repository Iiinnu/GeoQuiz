import Foundation
import SwiftData

/// Highest total round score ever achieved (out of `QuizSession.maxPossibleRoundScore`).
/// Exactly one row should exist — see `GameStatsStore.fetchOrCreateHighScore`.
@Model
final class HighScoreRecord {
    var bestScore: Int

    init(bestScore: Int = 0) {
        self.bestScore = bestScore
    }
}

/// One row per mode, accumulating points and question counts across every question ever
/// answered in that mode (not just one round) — the basis for "strongest category".
@Model
final class ModeStatRecord {
    var modeRawValue: String
    var totalPointsEarned: Int
    var questionsAnswered: Int

    init(mode: GameMode) {
        self.modeRawValue = mode.rawValue
        self.totalPointsEarned = 0
        self.questionsAnswered = 0
    }

    var mode: GameMode { GameMode(rawValue: modeRawValue) ?? .capitals }

    /// Average points per question (0...3) — a mode played entirely without hints or
    /// clues sits at 3.0. This already folds in how much help was needed, which is why
    /// it's used instead of a plain "percent correct".
    var averagePointsPerQuestion: Double {
        questionsAnswered == 0 ? 0 : Double(totalPointsEarned) / Double(questionsAnswered)
    }
}

extension Array where Element == ModeStatRecord {
    /// The mode with the highest average points-per-question, restricted to modes with at
    /// least `minimumSampleSize` questions answered so an early lucky streak in a
    /// barely-played mode can't outrank a mode that's actually been played a lot. Returns
    /// nil until some mode clears that bar.
    func strongestCategory(minimumSampleSize: Int = 10) -> GameMode? {
        filter { $0.questionsAnswered >= minimumSampleSize }
            .max { $0.averagePointsPerQuestion < $1.averagePointsPerQuestion }
            .map(\.mode)
    }
}

/// One row per (mode, country) that's been asked in the current cycle for that mode. Rows
/// for a mode are deleted in bulk once every country has appeared in it, so the cycle
/// restarts — see `GameStatsStore.excludedCountryIDs`.
@Model
final class AskedQuestionRecord {
    var modeRawValue: String
    var countryID: String

    init(mode: GameMode, countryID: String) {
        self.modeRawValue = mode.rawValue
        self.countryID = countryID
    }

    var mode: GameMode { GameMode(rawValue: modeRawValue) ?? .capitals }
}
