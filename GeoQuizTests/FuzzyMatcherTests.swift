import XCTest
@testable import GeoQuiz

final class FuzzyMatcherTests: XCTestCase {
    func testExactMatch() {
        XCTAssertTrue(FuzzyMatcher.matches("Sweden", "Sweden"))
    }

    func testCaseAndWhitespaceInsensitive() {
        XCTAssertTrue(FuzzyMatcher.matches("  sweden  ", "Sweden"))
    }

    func testDiacriticsInsensitive() {
        XCTAssertTrue(FuzzyMatcher.matches("Brasilia", "Brasília"))
    }

    func testMinorTypoPasses() {
        XCTAssertTrue(FuzzyMatcher.matches("Stockholom", "Stockholm"))
        XCTAssertTrue(FuzzyMatcher.matches("Fance", "France"))
    }

    func testPunctuationNormalized() {
        XCTAssertTrue(FuzzyMatcher.matches("Washington DC", "Washington, D.C."))
    }

    func testShortWordsRequireExactMatch() {
        // 2-letter-class strings shouldn't fuzzy-match a different short word.
        XCTAssertFalse(FuzzyMatcher.matches("UK", "US"))
    }

    func testWrongAnswerFails() {
        XCTAssertFalse(FuzzyMatcher.matches("Germany", "France"))
    }

    func testTooManyEditsFails() {
        XCTAssertFalse(FuzzyMatcher.matches("Xyzzyx", "France"))
    }

    func testMatchesAnyOfCandidates() {
        XCTAssertTrue(FuzzyMatcher.matches("usa", anyOf: ["United States", "USA", "US"]))
        XCTAssertFalse(FuzzyMatcher.matches("Canada", anyOf: ["United States", "USA", "US"]))
    }

    func testEmptyInputNeverMatches() {
        XCTAssertFalse(FuzzyMatcher.matches("", "France"))
    }

    func testCollisionAwareMatchRejectsCloseNeighborCountry() {
        // "Austria" is a real country, not a typo of "Australia" — even though it's
        // within the plain edit-distance threshold, it must not be accepted here.
        XCTAssertFalse(FuzzyMatcher.isCorrect(
            "Austria",
            targetAnswers: ["Australia"],
            distractorAnswers: ["Austria", "Sweden", "France"]
        ))
    }

    func testCollisionAwareMatchAcceptsTypoNotConfusableWithDistractor() {
        XCTAssertTrue(FuzzyMatcher.isCorrect(
            "Fance",
            targetAnswers: ["France"],
            distractorAnswers: ["Austria", "Sweden", "Germany"]
        ))
    }

    func testCollisionAwareMatchAlwaysAcceptsExactMatch() {
        // Exact match is unambiguous even if a distractor happens to be just as close.
        XCTAssertTrue(FuzzyMatcher.isCorrect(
            "Chad",
            targetAnswers: ["Chad"],
            distractorAnswers: ["Chile"]
        ))
    }

    func testCollisionAwareMatchAgainstFullDataset() {
        for country in CountryData.all {
            let distractorNames = CountryData.all
                .filter { $0.id != country.id }
                .flatMap(\.acceptableNameAnswers)
            XCTAssertTrue(
                FuzzyMatcher.isCorrect(country.name, targetAnswers: country.acceptableNameAnswers, distractorAnswers: distractorNames),
                "Exact country name '\(country.name)' should always match itself"
            )
            for other in CountryData.all where other.id != country.id {
                XCTAssertFalse(
                    FuzzyMatcher.isCorrect(other.name, targetAnswers: country.acceptableNameAnswers, distractorAnswers: distractorNames),
                    "'\(other.name)' should not match the question for '\(country.name)'"
                )
            }
        }
    }

    func testLevenshteinDistanceKnownValues() {
        XCTAssertEqual(FuzzyMatcher.levenshteinDistance("kitten", "sitting"), 3)
        XCTAssertEqual(FuzzyMatcher.levenshteinDistance("", "abc"), 3)
        XCTAssertEqual(FuzzyMatcher.levenshteinDistance("abc", "abc"), 0)
    }
}
