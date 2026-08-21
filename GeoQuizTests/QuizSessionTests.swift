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

        // Wrong guess after the hint escalates to the stronger clue rather than missing.
        session.submit("still wrong")
        guard case .awaitingRetry = session.state else {
            return XCTFail("expected the stronger clue, not a miss, right after the hint")
        }

        session.requestHint()
        guard case .awaitingRetry(let thirdClue) = session.state else {
            return XCTFail("expected clue state to remain")
        }
        XCTAssertNotEqual(thirdClue, firstClue, "hint shouldn't roll the state back to the weaker clue")

        // Now on the strongest clue — this wrong guess is the one that finally misses.
        session.submit("still wrong again")
        XCTAssertEqual(session.state, .missed)

        session.requestHint()
        XCTAssertEqual(session.state, .missed, "hint should be a no-op once the question is resolved")
    }

    func testCapitalsHintThenWrongEscalatesToStartsWithClueInsteadOfMissing() {
        let session = QuizSession(modes: [.capitals])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        guard case .awaitingRetry(let hintClue) = session.state else {
            return XCTFail("expected clue state after requesting a hint")
        }
        XCTAssertEqual(hintClue, ClueProvider.letterCountClue(for: question))

        // The hint (letter count) shouldn't burn your only retry with nothing gained —
        // a wrong guess right after it should reveal the starting letter, not miss
        // outright.
        session.submit("definitely not the answer")
        guard case .awaitingRetry(let secondClue) = session.state else {
            return XCTFail("expected a second, stronger clue instead of missing")
        }
        XCTAssertEqual(secondClue, ClueProvider.startsWithClue(for: question))

        // Only the next wrong guess (now on the strongest clue) ends the question.
        session.submit("still not the answer")
        XCTAssertEqual(session.state, .missed)
    }

    func testFlagsHintThenWrongEscalatesToStartsWithClueInsteadOfMissing() {
        let session = QuizSession(modes: [.flags])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        guard case .awaitingRetry(let hintClue) = session.state else {
            return XCTFail("expected clue state after requesting a hint")
        }
        XCTAssertEqual(hintClue, ClueProvider.regionClue(for: question))

        // The hint shouldn't burn your only retry with nothing gained — a wrong guess
        // right after it should reveal the stronger starts-with clue, not miss outright.
        session.submit("definitely not the answer")
        guard case .awaitingRetry(let secondClue) = session.state else {
            return XCTFail("expected a second, stronger clue instead of missing")
        }
        XCTAssertEqual(secondClue, ClueProvider.startsWithClue(for: question))

        // Only the next wrong guess (now on the strongest clue) ends the question.
        session.submit("still not the answer")
        XCTAssertEqual(session.state, .missed)
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

    func testContoursHintThenWrongEscalatesToStrongerClueInsteadOfMissing() {
        let session = QuizSession(modes: [.contours])
        guard let question = session.currentQuestion else { return XCTFail("no question") }

        session.requestHint()
        guard case .awaitingRetry(let hintClue) = session.state else {
            return XCTFail("expected clue state after requesting a hint")
        }
        XCTAssertEqual(hintClue, ClueProvider.regionClue(for: question))

        // The hint shouldn't burn your only retry with nothing gained — a wrong guess
        // right after it should reveal the stronger clue (a real border, or the
        // starts-with fallback for island nations), not miss outright either way, since
        // both differ from the region-only hint. bordersClue() picks a random neighbor
        // each call, so check the clue's shape/membership rather than re-deriving an
        // exact expected string (which could legitimately name a different neighbor).
        session.submit("definitely not the answer")
        guard case .awaitingRetry(let secondClue) = session.state else {
            return XCTFail("expected a second, stronger clue instead of missing")
        }
        if let neighbors = BorderData.neighbors[question.country.id], !neighbors.isEmpty {
            XCTAssertTrue(secondClue.hasPrefix("It shares a border with "))
            XCTAssertTrue(neighbors.contains { secondClue.contains($0) })
        } else {
            XCTAssertEqual(secondClue, ClueProvider.startsWithClue(for: question))
        }

        // Only the next wrong guess (now on the strongest clue) ends the question.
        session.submit("still not the answer")
        XCTAssertEqual(session.state, .missed)
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

    func testAerialHintThenWrongEscalatesToStartsWithClueInsteadOfMissing() {
        let session = QuizSession(modes: [.aerial])
        guard let question = session.currentQuestion else { return XCTFail("no question") }
        XCTAssertEqual(question.target, .aerialCityName)

        session.requestHint()
        guard case .awaitingRetry(let hintClue) = session.state else {
            return XCTFail("expected clue state after requesting a hint")
        }
        XCTAssertEqual(hintClue, ClueProvider.continentPopulationClue(for: question))

        session.submit("definitely not the answer")
        guard case .awaitingRetry(let secondClue) = session.state else {
            return XCTFail("expected a second, stronger clue instead of missing")
        }
        XCTAssertEqual(secondClue, ClueProvider.startsWithClue(for: question))

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
        XCTAssertEqual(session.score, session.totalCount)
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
