import XCTest
@testable import GeoQuiz

@MainActor
final class QuizSessionTests: XCTestCase {
    func testCorrectFirstTryScoresAndAdvances() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.submit(question.primaryAnswer)
        XCTAssertEqual(session.state, .correct)
        XCTAssertEqual(session.score, 1)

        session.advance()
        XCTAssertEqual(session.currentIndex, 1)
        XCTAssertEqual(session.state, .answering)
    }

    func testWrongThenClueThenCorrectCountsAsCorrect() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.submit("definitely not the answer")
        guard case .awaitingRetry(let clue) = session.state else {
            return XCTFail("expected clue state")
        }
        XCTAssertFalse(clue.isEmpty)

        session.submit(question.primaryAnswer)
        XCTAssertEqual(session.state, .correct)
        XCTAssertEqual(session.score, 1)
        XCTAssertEqual(session.results.first?.usedClue, true)
    }

    func testWrongTwiceIsMissed() {
        let session = QuizSession(modes: [.capitals])
        session.submit("nope")
        session.submit("still nope")

        XCTAssertEqual(session.state, .missed)
        XCTAssertEqual(session.score, 0)
        XCTAssertEqual(session.results.first?.wasCorrect, false)
    }

    func testHintShowsClueWithoutRequiringAWrongGuess() {
        let session = QuizSession(modes: [.capitals])
        session.requestHint()
        guard case .awaitingRetry(let clue) = session.state else {
            return XCTFail("expected clue state after requesting a hint")
        }
        XCTAssertFalse(clue.isEmpty)
        XCTAssertEqual(session.results.count, 0, "requesting a hint shouldn't record a result by itself")
    }

    func testCorrectAnswerAfterHintStillCountsAsCorrect() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        session.submit(question.primaryAnswer)

        XCTAssertEqual(session.state, .correct)
        XCTAssertEqual(session.score, 1)
        XCTAssertEqual(session.results.first?.usedClue, true)
    }

    func testHintDoesNothingOnceAlreadyShowingAClueOrResolved() {
        let session = QuizSession(modes: [.capitals])
        session.requestHint()
        guard case .awaitingRetry(let firstClue) = session.state else {
            return XCTFail("expected clue state")
        }

        session.requestHint()
        guard case .awaitingRetry(let secondClue) = session.state else {
            return XCTFail("expected clue state to remain")
        }
        XCTAssertEqual(firstClue, secondClue)

        session.submit("still wrong")
        XCTAssertEqual(session.state, .missed)

        session.requestHint()
        XCTAssertEqual(session.state, .missed, "hint should be a no-op once the question is resolved")
    }

    func testCapitalsHintAndWrongGuessGiveTheSameCombinedClue() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        guard case .awaitingRetry(let hintClue) = session.state else {
            return XCTFail("expected clue state after requesting a hint")
        }
        XCTAssertEqual(hintClue, ClueProvider.combinedClue(for: question))

        session.submit("definitely not the answer")
        XCTAssertEqual(session.state, .missed, "one retry only — wrong after the hint ends the question")
    }

    func testFlagsHintGivesRegionClueWrongGuessGivesStartsWithClue() {
        let session = QuizSession(modes: [.flags])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        guard case .awaitingRetry(let hintClue) = session.state else {
            return XCTFail("expected clue state after requesting a hint")
        }
        XCTAssertEqual(hintClue, ClueProvider.regionClue(for: question))

        session.submit("definitely not the answer")
        XCTAssertEqual(session.state, .missed, "one retry only — wrong after the hint ends the question")
    }

    func testFlagsWrongGuessWithoutHintGivesStartsWithClueNotRegionClue() {
        let session = QuizSession(modes: [.flags])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.submit("definitely not the answer")
        guard case .awaitingRetry(let clue) = session.state else {
            return XCTFail("expected clue state")
        }
        XCTAssertEqual(clue, ClueProvider.startsWithClue(for: question))
        XCTAssertNotEqual(clue, ClueProvider.regionClue(for: question))
    }

    func testContoursHintGivesRegionClueWrongGuessGivesBordersClue() {
        let session = QuizSession(modes: [.contours])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        guard case .awaitingRetry(let hintClue) = session.state else {
            return XCTFail("expected clue state after requesting a hint")
        }
        XCTAssertEqual(hintClue, ClueProvider.regionClue(for: question))

        session.submit("definitely not the answer")
        XCTAssertEqual(session.state, .missed, "one retry only — wrong after the hint ends the question")
    }

    func testContoursWrongGuessWithoutHintGivesBordersOrStartsWithClueNotRegionClue() {
        let session = QuizSession(modes: [.contours])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.submit("definitely not the answer")
        guard case .awaitingRetry(let clue) = session.state else {
            return XCTFail("expected clue state")
        }
        let expected = ClueProvider.bordersClue(for: question) != nil
            ? clue.contains("shares a border with")
            : clue == ClueProvider.startsWithClue(for: question)
        XCTAssertTrue(expected, "expected a borders clue (with a real neighbor) or a starts-with fallback, got: \(clue)")
        XCTAssertNotEqual(clue, ClueProvider.regionClue(for: question))
    }

    func testSessionHasTwentyQuestions() {
        let session = QuizSession(modes: [.capitals])
        XCTAssertEqual(session.totalCount, 20)
    }

    func testFinishesAfterAllQuestions() {
        let session = QuizSession(modes: [.capitals])
        for _ in 0..<session.totalCount {
            guard let question = session.currentQuestion else { break }
            session.submit(question.primaryAnswer)
            session.advance()
        }
        XCTAssertTrue(session.isFinished)
        XCTAssertEqual(session.score, session.totalCount)
    }
}
