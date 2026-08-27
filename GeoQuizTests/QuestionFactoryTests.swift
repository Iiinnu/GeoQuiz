import XCTest
@testable import GeoQuiz

final class QuestionFactoryTests: XCTestCase {
    func testExcludedCountriesAreNotRepeatedWhenPoolHasEnoughRemaining() {
        let countries = CountryData.all
        let excludedIDs = Set(countries.prefix(50).map(\.id))
        let questions = QuestionFactory.makeSession(
            modes: [.capitals],
            countries: countries,
            questionCount: 5,
            excludedCountryIDs: [.capitals: excludedIDs]
        )
        XCTAssertEqual(questions.count, 5)
        XCTAssertTrue(questions.allSatisfy { !excludedIDs.contains($0.country.id) })
    }

    func testExhaustedPoolStillFillsTheRound() {
        let countries = CountryData.all
        let allIDs = Set(countries.map(\.id))
        let questions = QuestionFactory.makeSession(
            modes: [.capitals],
            countries: countries,
            questionCount: 10,
            excludedCountryIDs: [.capitals: allIDs]
        )
        XCTAssertEqual(questions.count, 10, "exhausting the pool shouldn't shrink the round")
    }

    func testNoDuplicateCountriesWithinASingleModeEvenAfterFallingBackToSeenOnes() {
        let countries = CountryData.all
        let allIDs = Set(countries.map(\.id))
        let questions = QuestionFactory.makeSession(
            modes: [.capitals],
            countries: countries,
            questionCount: 15,
            excludedCountryIDs: [.capitals: allIDs]
        )
        let countryIDs = questions.map(\.country.id)
        XCTAssertEqual(Set(countryIDs).count, countryIDs.count, "a round shouldn't ask about the same country twice in one mode")
    }

    func testExclusionIsPerModeIndependent() {
        let countries = CountryData.all
        let excludedIDs = Set(countries.map(\.id))
        let questions = QuestionFactory.makeSession(
            modes: [.flags],
            countries: countries,
            questionCount: 5,
            excludedCountryIDs: [.capitals: excludedIDs]
        )
        XCTAssertEqual(questions.count, 5)
        XCTAssertTrue(questions.allSatisfy { $0.mode == .flags }, "excluding Capitals' pool shouldn't affect Flags")
    }

    // MARK: - Expansion: shared pool, no old-vs-new distinction

    func testNewlyAddedCountriesAreEligibleAlongsideTheOriginalSet() {
        let expansionIDs: Set<String> = [
            "VE", "EC", "UY", "BO", "IR", "MY", "SG", "BD", "LK", "AE", "MN",
            "DZ", "ET", "GH", "TZ", "ZW", "SN", "CD",
        ]
        // Draw many full-size rounds and confirm at least one new-set country turns up —
        // there's no special-casing that would keep them siloed from the original 58, so
        // over enough draws from the full pool this is effectively certain.
        var seenExpansionCountry = false
        for _ in 0..<25 {
            let questions = QuestionFactory.makeSession(modes: [.capitals], questionCount: 20)
            if questions.contains(where: { expansionIDs.contains($0.country.id) }) {
                seenExpansionCountry = true
                break
            }
        }
        XCTAssertTrue(seenExpansionCountry, "expansion countries never appeared across 25 rounds — check they're reachable from the shared pool")
    }
}
