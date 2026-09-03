import Foundation

/// Where a question currently sits in the shared answer flow (used by every mode):
/// answering -> Hint 1 and/or a wrong guess -> Hint 2 shown -> correct or missed. Hint 2
/// always contains Hint 1's content plus more (see `HintProvider`), so a wrong guess after
/// Hint 1 reveals genuinely new information rather than ending the question outright —
/// using Hint 1 never wastes your only retry.
enum QuestionState: Equatable {
    case answering
    case awaitingRetry(hint: String)
    case correct
    case missed
}

struct QuestionResult: Identifiable {
    let id = UUID()
    let question: Question
    let wasCorrect: Bool
    let pointsEarned: Int
}

@MainActor
final class QuizSession: ObservableObject {
    static let maxPointsPerQuestion = 3
    static let questionsPerRound = 20
    static let maxPossibleRoundScore = maxPointsPerQuestion * questionsPerRound

    let questions: [Question]

    @Published private(set) var currentIndex = 0
    @Published private(set) var state: QuestionState = .answering
    @Published private(set) var results: [QuestionResult] = []

    private var hasShownHint1 = false
    private var hasShownHint2 = false

    init(modes: Set<GameMode>, excludedCountryIDs: [GameMode: Set<String>] = [:]) {
        self.questions = QuestionFactory.makeSession(
            modes: modes,
            questionCount: Self.questionsPerRound,
            excludedCountryIDs: excludedCountryIDs
        )
    }

    var currentQuestion: Question? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var isFinished: Bool { currentIndex >= questions.count }

    var score: Int { results.reduce(0) { $0 + $1.pointsEarned } }
    var maxScore: Int { questions.count * Self.maxPointsPerQuestion }
    var totalCount: Int { questions.count }

    /// Every country this round will ask about (or already has), grouped by mode — used to
    /// mark them as "asked" in `GameStatsStore` so they aren't repeated until the rest of
    /// that mode's pool has been cycled through.
    var countryIDsByMode: [GameMode: [String]] {
        Dictionary(grouping: questions, by: \.mode).mapValues { $0.map { $0.country.id } }
    }

    /// This round's points and question count per mode, folded into `GameStatsStore`'s
    /// running per-mode totals once the round finishes.
    var perModePointsTally: [GameMode: (points: Int, count: Int)] {
        var tally: [GameMode: (points: Int, count: Int)] = [:]
        for result in results {
            var entry = tally[result.question.mode] ?? (points: 0, count: 0)
            entry.points += result.pointsEarned
            entry.count += 1
            tally[result.question.mode] = entry
        }
        return tally
    }

    /// Submits the player's current text input for grading.
    func submit(_ input: String) {
        guard let question = currentQuestion, !isFinished else { return }
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let isMatch = FuzzyMatcher.isCorrect(
            trimmed,
            targetAnswers: question.acceptableAnswers,
            distractorAnswers: distractorAnswers(for: question)
        )

        switch state {
        case .answering, .awaitingRetry:
            if isMatch {
                recordResult(wasCorrect: true)
            } else {
                advanceToHint2OrMiss(for: question)
            }
        case .correct, .missed:
            break
        }
    }

    /// Shows Hint 1 on demand, without requiring a wrong guess first — so a player who
    /// just doesn't know the answer isn't forced to type a throwaway guess to unlock it.
    func requestHint() {
        guard let question = currentQuestion, state == .answering else { return }
        hasShownHint1 = true
        state = .awaitingRetry(hint: HintProvider.hint1(for: question))
    }

    /// After a wrong guess: shows Hint 2 for one more try instead of ending the question
    /// outright, unless Hint 2 was already showing (i.e. this is the second wrong guess),
    /// in which case the question is missed.
    private func advanceToHint2OrMiss(for question: Question) {
        guard !hasShownHint2 else {
            recordResult(wasCorrect: false)
            return
        }
        hasShownHint2 = true
        state = .awaitingRetry(hint: HintProvider.hint2(for: question))
    }

    /// Every other country's real answers for the same field, so the matcher can tell a
    /// typo apart from an honest wrong answer that happens to look similar (see
    /// `FuzzyMatcher.isCorrect`). Drawn from the full dataset, not just this session's 20
    /// questions, since a country outside today's sample is still a valid false positive.
    private func distractorAnswers(for question: Question) -> [String] {
        switch question.target {
        case .countryName, .capitalName, .aerialCityName:
            return CountryData.all
                .filter { $0.id != question.country.id }
                .flatMap { other -> [String] in
                    switch question.target {
                    case .countryName: return other.acceptableNameAnswers
                    case .capitalName: return other.acceptableCapitalAnswers
                    case .aerialCityName: return other.acceptableAerialCityAnswers
                    case .landmarkPlace: return []
                    }
                }
        case .landmarkPlace:
            return LandmarkData.all
                .filter { $0.id != question.landmark?.id }
                .flatMap(\.acceptablePlaceAnswers)
        }
    }

    /// Points reflect how much help was needed: 3 for a first-try correct answer, 2 if
    /// Hint 1 was used but no guess was ever wrong, 1 if a wrong guess required Hint 2
    /// (even if Hint 1 was also used earlier), 0 if missed.
    private func recordResult(wasCorrect: Bool) {
        guard let question = currentQuestion else { return }
        state = wasCorrect ? .correct : .missed
        let points: Int
        if !wasCorrect {
            points = 0
        } else if hasShownHint2 {
            points = 1
        } else if hasShownHint1 {
            points = 2
        } else {
            points = 3
        }
        results.append(QuestionResult(question: question, wasCorrect: wasCorrect, pointsEarned: points))
    }

    /// Advances to the next question after a correct/missed result has been shown.
    func advance() {
        currentIndex += 1
        state = .answering
        hasShownHint1 = false
        hasShownHint2 = false
    }
}
