import XCTest
@testable import GeoQuiz

final class ClueProviderTests: XCTestCase {
    private let sweden = Country(id: "SE", name: "Sweden", capital: "Stockholm", region: .europe)

    func testClueForCapitalTarget() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        let clue = ClueProvider.clue(for: question)
        XCTAssertTrue(clue.contains("capital"))
        XCTAssertTrue(clue.contains("'S'"))
        XCTAssertTrue(clue.contains("9 letters"))
        XCTAssertTrue(clue.contains("Europe"))
    }

    func testClueForCountryTarget() {
        let question = Question(mode: .capitals, country: sweden, target: .countryName)
        let clue = ClueProvider.clue(for: question)
        XCTAssertTrue(clue.contains("country"))
        XCTAssertTrue(clue.contains("'S'"))
        XCTAssertTrue(clue.contains("6 letters"))
    }

    func testClueDoesNotRevealFullAnswer() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        let clue = ClueProvider.clue(for: question)
        XCTAssertFalse(clue.contains("Stockholm"))
    }
}
