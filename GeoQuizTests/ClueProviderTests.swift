import XCTest
@testable import GeoQuiz

final class ClueProviderTests: XCTestCase {
    private let sweden = Country(id: "SE", name: "Sweden", capital: "Stockholm", region: .europe)

    func testRegionClueRevealsRegionOnly() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        let clue = ClueProvider.regionClue(for: question)
        XCTAssertTrue(clue.contains("Europe"))
        XCTAssertFalse(clue.contains("Stockholm"))
        XCTAssertFalse(clue.contains("'S'"), "region clue shouldn't also give away the starting letter")
    }

    func testStartsWithClueForCapitalTarget() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        let clue = ClueProvider.startsWithClue(for: question)
        XCTAssertTrue(clue.contains("capital"))
        XCTAssertTrue(clue.contains("'S'"))
    }

    func testStartsWithClueForCountryTarget() {
        let question = Question(mode: .capitals, country: sweden, target: .countryName)
        let clue = ClueProvider.startsWithClue(for: question)
        XCTAssertTrue(clue.contains("country"))
        XCTAssertTrue(clue.contains("'S'"))
    }

    func testNeitherClueRevealsTheFullAnswer() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        XCTAssertFalse(ClueProvider.regionClue(for: question).contains("Stockholm"))
        XCTAssertFalse(ClueProvider.startsWithClue(for: question).contains("Stockholm"))
    }
}
