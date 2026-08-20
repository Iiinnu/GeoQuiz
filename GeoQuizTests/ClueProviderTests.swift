import XCTest
@testable import GeoQuiz

final class ClueProviderTests: XCTestCase {
    private let sweden = Country(id: "SE", name: "Sweden", capital: "Stockholm", region: .europe)

    // MARK: Capitals — hint gives letter count only, wrong guess gives starting letter only

    func testCapitalsHintGivesLetterCountOnly() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        let clue = ClueProvider.hintClue(for: question)
        XCTAssertTrue(clue.contains("9 letters"))
        XCTAssertFalse(clue.contains("'S'"), "capitals hint shouldn't also give away the starting letter")
        XCTAssertFalse(clue.contains("Europe"), "capitals hint shouldn't also give away the region")
    }

    func testCapitalsWrongGuessGivesStartsWithOnly() {
        let question = Question(mode: .capitals, country: sweden, target: .countryName)
        let clue = ClueProvider.wrongGuessClue(for: question)
        XCTAssertTrue(clue.contains("country"))
        XCTAssertTrue(clue.contains("'S'"))
        XCTAssertFalse(clue.contains("6 letters"), "capitals wrong-guess clue shouldn't also give away the letter count")
    }

    func testCapitalsHintAndWrongGuessDiffer() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        XCTAssertNotEqual(ClueProvider.hintClue(for: question), ClueProvider.wrongGuessClue(for: question))
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

    // MARK: Contours — hint gives region only, wrong guess names a real bordering country

    func testContoursHintGivesRegionOnly() {
        let question = Question(mode: .contours, country: sweden, target: .countryName)
        let clue = ClueProvider.hintClue(for: question)
        XCTAssertTrue(clue.contains("Europe"))
    }

    func testContoursWrongGuessNamesARealNeighbor() {
        let question = Question(mode: .contours, country: sweden, target: .countryName)
        let clue = ClueProvider.wrongGuessClue(for: question)
        XCTAssertTrue(
            clue.contains("Finland") || clue.contains("Norway"),
            "expected Sweden's clue to name one of its real neighbors, got: \(clue)"
        )
        XCTAssertFalse(clue.contains("'S'"), "contours wrong-guess clue shouldn't fall back to the starting letter when a neighbor exists")
    }

    func testContoursFallsBackToStartsWithClueForIslandNations() {
        let australia = Country(id: "AU", name: "Australia", capital: "Canberra", region: .oceania)
        let question = Question(mode: .contours, country: australia, target: .countryName)
        let clue = ClueProvider.wrongGuessClue(for: question)
        XCTAssertEqual(clue, ClueProvider.startsWithClue(for: question))
    }

    func testBordersClueReturnsNilForIslandNations() {
        let australia = Country(id: "AU", name: "Australia", capital: "Canberra", region: .oceania)
        let question = Question(mode: .contours, country: australia, target: .countryName)
        XCTAssertNil(ClueProvider.bordersClue(for: question))
    }
}
