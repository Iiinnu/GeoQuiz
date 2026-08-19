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

    func testLevenshteinDistanceKnownValues() {
        XCTAssertEqual(FuzzyMatcher.levenshteinDistance("kitten", "sitting"), 3)
        XCTAssertEqual(FuzzyMatcher.levenshteinDistance("", "abc"), 3)
        XCTAssertEqual(FuzzyMatcher.levenshteinDistance("abc", "abc"), 0)
    }
}
