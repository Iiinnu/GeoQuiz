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

    func testAerialCorrectAnswerMatchesTheCityNotTheCountry() throws {
        let session = QuizSession(modes: [.aerial])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        // Skip the rare case where the country name genuinely IS the correct answer --
        // Singapore is a city-state whose Aerial answer equals its own country name, so
        // this test's premise ("the country name alone shouldn't count as correct")
        // doesn't apply to it. Without this, the test flakes on a ~1-in-79 random draw.
        try XCTSkipIf(question.country.name == question.primaryAnswer)

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

    // MARK: - Landmarks: landmarkPlace answers (historic/pop-culture batch)

    func testLandmarksCityStateOrPlacenameAnswerScoresCorrectFirstTry() {
        // Draw sessions until one starts on a non-country-answer Landmarks question, then
        // submit its real answer text end-to-end through FuzzyMatcher/QuizSession.
        for _ in 0..<60 {
            let session = QuizSession(modes: [.landmarks])
            guard let question = session.currentQuestion, question.target == .landmarkPlace else { continue }
            guard let answer = question.landmark?.answerText else { return XCTFail("landmarkPlace question missing answerText") }
            session.submit(answer)
            XCTAssertEqual(session.state, .correct, "submitting the real answer text ('\(answer)') should score correct")
            return
        }
        XCTFail("never drew a non-country-answer Landmarks question across 60 sessions")
    }

    // MARK: - Aerial: extra satellite cities (56-city expansion)

    func testAerialExtraCityAnswerScoresCorrectFirstTry() {
        // Draw sessions until one starts on a non-default satellite city, then submit its
        // real city name end-to-end through FuzzyMatcher/QuizSession.
        for _ in 0..<60 {
            let session = QuizSession(modes: [.aerial])
            guard let question = session.currentQuestion,
                  let satelliteCity = question.satelliteCity,
                  !satelliteCity.id.hasSuffix("_default") else { continue }
            session.submit(satelliteCity.cityName)
            XCTAssertEqual(session.state, .correct, "submitting the real city name ('\(satelliteCity.cityName)') should score correct")
            return
        }
        XCTFail("never drew a non-default Aerial question across 60 sessions")
    }
}
