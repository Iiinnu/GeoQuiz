import Foundation

/// Where a question currently sits in the shared answer flow (used by every mode):
/// answering -> (wrong) -> clue shown, one retry -> correct or missed.
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
        let isMatch = FuzzyMatcher.matches(trimmed, anyOf: question.acceptableAnswers)

        switch state {
        case .answering:
            if isMatch {
                recordResult(wasCorrect: true, usedClue: false)
            } else {
                state = .awaitingRetry(clue: ClueProvider.clue(for: question))
            }
        case .awaitingRetry:
            recordResult(wasCorrect: isMatch, usedClue: true)
        case .correct, .missed:
            break
        }
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
    }
}
