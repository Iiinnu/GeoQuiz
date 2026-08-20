import Foundation

/// Where a question currently sits in the shared answer flow (used by every mode):
/// answering -> (hint or wrong) -> clue shown -> correct or missed. If the hint's clue
/// and the wrong-guess clue actually differ (they do for Flags/Contours/Aerial, not for
/// Capitals — see ClueProvider), a wrong guess after the hint reveals that stronger clue
/// instead of ending the question, so using the hint doesn't waste your only retry.
enum QuestionState: Equatable {
    case answering
    case awaitingRetry(clue: String)
    case correct
    case missed
}

struct QuestionResult: Identifiable {
    let id = UUID()
    let question: Question
    let wasCorrect: Bool
    let usedClue: Bool
}

@MainActor
final class QuizSession: ObservableObject {
    let questions: [Question]

    @Published private(set) var currentIndex = 0
    @Published private(set) var state: QuestionState = .answering
    @Published private(set) var results: [QuestionResult] = []

    private var hasShownHintClue = false
    private var hasShownStrongClue = false

    init(modes: Set<GameMode>) {
        self.questions = QuestionFactory.makeSession(modes: modes)
    }

    var currentQuestion: Question? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var isFinished: Bool { currentIndex >= questions.count }

    var score: Int { results.filter(\.wasCorrect).count }
    var totalCount: Int { questions.count }

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
                recordResult(wasCorrect: true, usedClue: hasShownHintClue || hasShownStrongClue)
            } else {
                advanceToNextClueOrMiss(for: question)
            }
        case .correct, .missed:
            break
        }
    }

    /// Shows the hint clue on demand, without requiring a wrong guess first — so a player
    /// who just doesn't know the answer isn't forced to type a throwaway guess to unlock
    /// it.
    func requestHint() {
        guard let question = currentQuestion, state == .answering else { return }
        hasShownHintClue = true
        state = .awaitingRetry(clue: ClueProvider.hintClue(for: question))
    }

    /// After a wrong guess: if the hint was already used and the wrong-guess clue is
    /// strictly stronger (actually different — not the case for Capitals, where both
    /// clues are the same combined string), show that stronger clue for one more try
    /// instead of ending the question, so the hint doesn't cost you your only retry with
    /// nothing gained. Otherwise resolves as missed, same as always.
    private func advanceToNextClueOrMiss(for question: Question) {
        guard !hasShownStrongClue else {
            recordResult(wasCorrect: false, usedClue: true)
            return
        }
        let strongClue = ClueProvider.wrongGuessClue(for: question)
        if hasShownHintClue && strongClue == ClueProvider.hintClue(for: question) {
            recordResult(wasCorrect: false, usedClue: true)
            return
        }
        hasShownStrongClue = true
        state = .awaitingRetry(clue: strongClue)
    }

    /// Every other country's real answers for the same field, so the matcher can tell a
    /// typo apart from an honest wrong answer that happens to look similar (see
    /// `FuzzyMatcher.isCorrect`). Drawn from the full dataset, not just this session's 20
    /// questions, since a country outside today's sample is still a valid false positive.
    private func distractorAnswers(for question: Question) -> [String] {
        CountryData.all
            .filter { $0.id != question.country.id }
            .flatMap { question.target == .countryName ? $0.acceptableNameAnswers : $0.acceptableCapitalAnswers }
    }

    private func recordResult(wasCorrect: Bool, usedClue: Bool) {
        guard let question = currentQuestion else { return }
        state = wasCorrect ? .correct : .missed
        results.append(QuestionResult(question: question, wasCorrect: wasCorrect, usedClue: usedClue))
    }

    /// Advances to the next question after a correct/missed result has been shown.
    func advance() {
        currentIndex += 1
        state = .answering
        hasShownHintClue = false
        hasShownStrongClue = false
    }
}
