import XCTest
@testable import GeoQuiz

@MainActor
final class QuizSessionTests: XCTestCase {
    func testCorrectFirstTryScoresAndAdvances() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.submit(question.primaryAnswer)
        XCTAssertEqual(session.state, .correct)
        XCTAssertEqual(session.score, 3, "first-try correct with no help earns full points")

        session.advance()
        XCTAssertEqual(session.currentIndex, 1)
        XCTAssertEqual(session.state, .answering)
    }

    func testWrongThenHint2ThenCorrectScoresOnePoint() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.submit("definitely not the answer")
        guard case .awaitingRetry(let hint) = session.state else {
            return XCTFail("expected hint state")
        }
        XCTAssertFalse(hint.isEmpty)

        session.submit(question.primaryAnswer)
        XCTAssertEqual(session.state, .correct)
        XCTAssertEqual(session.score, 1)
        XCTAssertEqual(session.results.first?.pointsEarned, 1)
    }

    func testWrongTwiceIsMissed() {
        let session = QuizSession(modes: [.capitals])
        session.submit("nope")
        session.submit("still nope")

        XCTAssertEqual(session.state, .missed)
        XCTAssertEqual(session.score, 0)
        XCTAssertEqual(session.results.first?.wasCorrect, false)
    }

    func testHintShowsHint1WithoutRequiringAWrongGuess() {
        let session = QuizSession(modes: [.capitals])
        session.requestHint()
        guard case .awaitingRetry(let hint) = session.state else {
            return XCTFail("expected hint state after requesting a hint")
        }
        XCTAssertFalse(hint.isEmpty)
        XCTAssertEqual(session.results.count, 0, "requesting a hint shouldn't record a result by itself")
    }

    func testCorrectAnswerAfterHintScoresTwoPoints() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        session.submit(question.primaryAnswer)

        XCTAssertEqual(session.state, .correct)
        XCTAssertEqual(session.score, 2, "using the pre-answer hint (without ever guessing wrong) costs one point")
        XCTAssertEqual(session.results.first?.pointsEarned, 2)
    }

    func testHintThenWrongThenCorrectScoresOnePointNotTwo() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        session.submit("definitely not the answer")
        guard case .awaitingRetry = session.state else {
            return XCTFail("expected Hint 2 after the wrong guess")
        }

        session.submit(question.primaryAnswer)
        XCTAssertEqual(session.state, .correct)
        XCTAssertEqual(
            session.score, 1,
            "needing Hint 2 caps the score at 1, even if Hint 1 was also used earlier"
        )
    }

    func testHintDoesNothingOnceAlreadyShowingAHintOrResolved() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        guard case .awaitingRetry(let firstHint) = session.state else {
            return XCTFail("expected hint state")
        }
        XCTAssertEqual(firstHint, HintProvider.hint1(for: question))

        session.requestHint()
        guard case .awaitingRetry(let secondHint) = session.state else {
            return XCTFail("expected hint state to remain")
        }
        XCTAssertEqual(firstHint, secondHint, "requesting the hint again shouldn't change anything")

        // Wrong guess after Hint 1 escalates to Hint 2 rather than missing.
        session.submit("still wrong")
        guard case .awaitingRetry(let hint2) = session.state else {
            return XCTFail("expected Hint 2, not a miss, right after Hint 1")
        }
        XCTAssertEqual(hint2, HintProvider.hint2(for: question))
        XCTAssertTrue(hint2.hasPrefix(firstHint), "Hint 2 should still contain everything Hint 1 said")

        session.requestHint()
        XCTAssertEqual(session.state, .awaitingRetry(hint: hint2), "hint should be a no-op once Hint 2 is already showing")

        // Now on Hint 2 — this wrong guess is the one that finally misses.
        session.submit("still wrong again")
        XCTAssertEqual(session.state, .missed)

        session.requestHint()
        XCTAssertEqual(session.state, .missed, "hint should be a no-op once the question is resolved")
    }

    func testCapitalsHintThenWrongEscalatesToHint2InsteadOfMissing() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        guard case .awaitingRetry(let hint1) = session.state else {
            return XCTFail("expected hint state after requesting a hint")
        }
        XCTAssertEqual(hint1, HintProvider.hint1(for: question))

        // Hint 1 shouldn't burn your only retry with nothing gained — a wrong guess right
        // after it should reveal Hint 2, not miss outright.
        session.submit("definitely not the answer")
        guard case .awaitingRetry(let hint2) = session.state else {
            return XCTFail("expected Hint 2 instead of missing")
        }
        XCTAssertEqual(hint2, HintProvider.hint2(for: question))

        // Only the next wrong guess (now on Hint 2) ends the question.
        session.submit("still not the answer")
        XCTAssertEqual(session.state, .missed)
    }

    func testFlagsWrongGuessWithoutHintGivesHint2Directly() {
        let session = QuizSession(modes: [.flags])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.submit("definitely not the answer")
        guard case .awaitingRetry(let hint) = session.state else {
            return XCTFail("expected hint state")
        }
        // Skipping Hint 1 doesn't lose its content — Hint 2 always contains it.
        XCTAssertEqual(hint, HintProvider.hint2(for: question))
        XCTAssertTrue(hint.hasPrefix(HintProvider.hint1(for: question)))
    }

    func testContoursHintThenWrongEscalatesToHint2InsteadOfMissing() {
        let session = QuizSession(modes: [.contours])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        guard case .awaitingRetry(let hint1) = session.state else {
            return XCTFail("expected hint state after requesting a hint")
        }
        XCTAssertEqual(hint1, HintProvider.hint1(for: question))

        session.submit("definitely not the answer")
        guard case .awaitingRetry(let hint2) = session.state else {
            return XCTFail("expected Hint 2 instead of missing")
        }
        XCTAssertEqual(hint2, HintProvider.hint2(for: question))

        session.submit("still not the answer")
        XCTAssertEqual(session.state, .missed)
    }

    func testAerialHintThenWrongEscalatesToHint2InsteadOfMissing() {
        let session = QuizSession(modes: [.aerial])
        guard let question = session.currentQuestion else { return XCTFail("no question") }
        XCTAssertEqual(question.target, .aerialCityName)

        session.requestHint()
        guard case .awaitingRetry(let hint1) = session.state else {
            return XCTFail("expected hint state after requesting a hint")
        }
        XCTAssertEqual(hint1, HintProvider.hint1(for: question))

        session.submit("definitely not the answer")
        guard case .awaitingRetry(let hint2) = session.state else {
            return XCTFail("expected Hint 2 instead of missing")
        }
        XCTAssertEqual(hint2, HintProvider.hint2(for: question))

        session.submit("still not the answer")
        XCTAssertEqual(session.state, .missed)
    }

    func testAerialCorrectAnswerMatchesTheCityNotTheCountry() {
        let session = QuizSession(modes: [.aerial])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        // The country name alone shouldn't count as correct for an Aerial question.
        session.submit(question.country.name)
        XCTAssertNotEqual(session.state, .correct)
    }

    func testAerialFinishesAfterAllQuestionsAnsweringWithTheCityName() {
        let session = QuizSession(modes: [.aerial])
        for _ in 0..<session.totalCount {
            guard let question = session.currentQuestion else { break }
            session.submit(question.primaryAnswer)
            session.advance()
        }
        XCTAssertTrue(session.isFinished)
        XCTAssertEqual(session.score, session.maxScore, "all first-try correct answers should earn full points")
    }

    func testSessionHasTwentyQuestions() {
        let session = QuizSession(modes: [.capitals])
        XCTAssertEqual(session.totalCount, 20)
    }

    func testMaxScoreIsThreeTimesTotalCount() {
        let session = QuizSession(modes: [.capitals])
        XCTAssertEqual(session.maxScore, session.totalCount * 3)
        XCTAssertEqual(session.maxScore, 60)
    }

    func testFinishesAfterAllQuestions() {
        let session = QuizSession(modes: [.capitals])
        for _ in 0..<session.totalCount {
            guard let question = session.currentQuestion else { break }
            session.submit(question.primaryAnswer)
            session.advance()
        }
        XCTAssertTrue(session.isFinished)
        XCTAssertEqual(session.score, session.maxScore, "all first-try correct answers should earn full points")
    }
}
