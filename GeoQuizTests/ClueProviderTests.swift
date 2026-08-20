import XCTest
@testable import GeoQuiz

final class ClueProviderTests: XCTestCase {
    private let sweden = Country(id: "SE", name: "Sweden", capital: "Stockholm", region: .europe)

    // MARK: Capitals — hint and wrong guess both give the same combined clue

    func testCapitalsHintGivesCombinedClue() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        let clue = ClueProvider.hintClue(for: question)
        XCTAssertTrue(clue.contains("capital"))
        XCTAssertTrue(clue.contains("'S'"))
        XCTAssertTrue(clue.contains("9 letters"))
        XCTAssertTrue(clue.contains("Europe"))
    }

    func testCapitalsWrongGuessGivesCombinedClue() {
        let question = Question(mode: .capitals, country: sweden, target: .countryName)
        let clue = ClueProvider.wrongGuessClue(for: question)
        XCTAssertTrue(clue.contains("country"))
        XCTAssertTrue(clue.contains("'S'"))
        XCTAssertTrue(clue.contains("6 letters"))
        XCTAssertTrue(clue.contains("Europe"))
    }

    func testCapitalsHintAndWrongGuessMatch() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        XCTAssertEqual(ClueProvider.hintClue(for: question), ClueProvider.wrongGuessClue(for: question))
    }

    // MARK: Flags — hint gives region only, wrong guess gives starting letter only

    func testFlagsHintGivesRegionOnly() {
        let question = Question(mode: .flags, country: sweden, target: .countryName)
        let clue = ClueProvider.hintClue(for: question)
        XCTAssertTrue(clue.contains("Europe"))
        XCTAssertFalse(clue.contains("'S'"), "flags hint shouldn't also give away the starting letter")
    }

    func testFlagsWrongGuessGivesStartsWithOnly() {
        let question = Question(mode: .flags, country: sweden, target: .countryName)
        let clue = ClueProvider.wrongGuessClue(for: question)
        XCTAssertTrue(clue.contains("'S'"))
        XCTAssertFalse(clue.contains("Europe"), "flags wrong-guess clue shouldn't also give away the region")
    }

    func testFlagsHintAndWrongGuessDiffer() {
        let question = Question(mode: .flags, country: sweden, target: .countryName)
        XCTAssertNotEqual(ClueProvider.hintClue(for: question), ClueProvider.wrongGuessClue(for: question))
    }

    func testNoCluesRevealTheFullAnswer() {
        let capitals = Question(mode: .capitals, country: sweden, target: .capitalName)
        let flags = Question(mode: .flags, country: sweden, target: .countryName)
        for clue in [
            ClueProvider.hintClue(for: capitals),
            ClueProvider.wrongGuessClue(for: capitals),
            ClueProvider.hintClue(for: flags),
            ClueProvider.wrongGuessClue(for: flags),
        ] {
            XCTAssertFalse(clue.contains("Stockholm"))
            XCTAssertFalse(clue.contains("Sweden"))
        }
    }
}
