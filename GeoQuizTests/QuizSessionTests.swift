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
