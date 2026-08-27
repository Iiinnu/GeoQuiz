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
}
