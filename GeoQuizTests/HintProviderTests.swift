import XCTest
@testable import GeoQuiz

final class HintProviderTests: XCTestCase {
    private let sweden = Country(id: "SE", name: "Sweden", capital: "Stockholm", region: .europe, populationMillions: 10)

    // MARK: Hint 1 — simple, region + population/border-count, no starting letter

    func testCapitalsHint1GivesRegionAndPopulation() {
        let question = Question(mode: .capitals, country: sweden, target: .capitalName)
        let hint = HintProvider.hint1(for: question)
        XCTAssertEqual(hint, "Europe. This country has a population of 10 million.")
    }

    func testFlagsHint1GivesRegionAndPopulationNotVisualDetail() {
        // The flag image is already fully visible on screen, so Hint 1 must not describe
        // anything visible in it (colors, symbols) — that would be zero new information.
        let question = Question(mode: .flags, country: sweden, target: .countryName)
        let hint = HintProvider.hint1(for: question)
        XCTAssertEqual(hint, "Europe. This country has a population of 10 million.")
    }

    func testContoursHint1GivesRegionAndBorderCount() {
        let question = Question(mode: .contours, country: sweden, target: .countryName)
        let hint = HintProvider.hint1(for: question)
        XCTAssertEqual(hint, "Europe. It shares a border with 2 other countries.")
    }

    func testContoursHint1PhrasesOneNeighborDifferently() {
        let portugal = Country(id: "PT", name: "Portugal", capital: "Lisbon", region: .europe, populationMillions: 10)
        let question = Question(mode: .contours, country: portugal, target: .countryName)
        XCTAssertEqual(HintProvider.hint1(for: question), "Europe. It shares a border with only one other country.")
    }

    func testContoursHint1PhrasesIslandNationsAsNoLandBorder() {
        let australia = Country(id: "AU", name: "Australia", capital: "Canberra", region: .oceania, populationMillions: 25)
        let question = Question(mode: .contours, country: australia, target: .countryName)
        XCTAssertEqual(HintProvider.hint1(for: question), "Oceania. It doesn't share a land border with any other country.")
    }

    func testAerialHint1GivesContinentAndPopulationPhrasedAroundTheCapital() {
        let question = Question(mode: .aerial, country: sweden, target: .aerialCityName)
        XCTAssertEqual(HintProvider.hint1(for: question), "Europe. It's the capital of a country with 10 million people.")
    }

    func testAerialHint1UsesTheOverriddenDescriptorAndCityWhenPresent() {
        let southAfrica = Country(
            id: "ZA", name: "South Africa", capital: "Pretoria", region: .africa, populationMillions: 59,
            aerialCityName: "Cape Town", aerialCityDescriptor: "a major city"
        )
        let question = Question(mode: .aerial, country: southAfrica, target: .aerialCityName)
        XCTAssertEqual(HintProvider.hint1(for: question), "Africa. It's a major city of a country with 59 million people.")
    }

    func testHint1NeverRevealsTheAnswer() {
        for mode in [GameMode.capitals, .flags, .contours, .aerial] {
            let question = Question(mode: mode, country: sweden, target: mode == .aerial ? .aerialCityName : .countryName)
            let hint = HintProvider.hint1(for: question)
            XCTAssertFalse(hint.contains("Stockholm"))
            XCTAssertFalse(hint.contains("Sweden"))
        }
    }

    // MARK: Hint 2 — always Hint 1's content, plus a fun fact, plus a starting letter

    func testHint2ContainsHint1InFull() {
        for mode in [GameMode.capitals, .flags, .contours, .aerial] {
            let question = Question(mode: mode, country: sweden, target: mode == .aerial ? .aerialCityName : .countryName)
            XCTAssertTrue(
                HintProvider.hint2(for: question).hasPrefix(HintProvider.hint1(for: question)),
                "Hint 2 should start with Hint 1's exact content for \(mode)"
            )
        }
    }

    func testHint2IncludesTheCountrysFunFact() {
        let question = Question(mode: .capitals, country: sweden, target: .countryName)
        let fact = CountryFunFacts.all["SE"]!
        XCTAssertTrue(HintProvider.hint2(for: question).contains(fact))
    }

    func testHint2IncludesStartingLetterOfTheActualAnswer() {
        // Sweden: country starts with 'S', capital (Stockholm) also starts with 'S' — use
        // a country where they differ to prove it's really the answer's letter.
        let egypt = Country(id: "EG", name: "Egypt", capital: "Cairo", region: .africa, populationMillions: 100)

        let countryQuestion = Question(mode: .capitals, country: egypt, target: .countryName)
        XCTAssertTrue(HintProvider.hint2(for: countryQuestion).contains("The country starts with 'E'."))

        let capitalQuestion = Question(mode: .capitals, country: egypt, target: .capitalName)
        XCTAssertTrue(HintProvider.hint2(for: capitalQuestion).contains("The capital starts with 'C'."))

        let aerialQuestion = Question(mode: .aerial, country: egypt, target: .aerialCityName)
        XCTAssertTrue(HintProvider.hint2(for: aerialQuestion).contains("The city starts with 'C'."))
    }

    func testHint1AndHint2AreNeverIdentical() {
        // True by construction (Hint 2 = Hint 1 + more), but worth locking in as a test —
        // this used to require a special-case check in QuizSession before this redesign.
        for mode in [GameMode.capitals, .flags, .contours, .aerial] {
            let question = Question(mode: mode, country: sweden, target: mode == .aerial ? .aerialCityName : .countryName)
            XCTAssertNotEqual(HintProvider.hint1(for: question), HintProvider.hint2(for: question))
        }
    }

    func testHint2NeverRevealsTheFullAnswer() {
        for mode in [GameMode.capitals, .flags, .contours, .aerial] {
            let question = Question(mode: mode, country: sweden, target: mode == .aerial ? .aerialCityName : .countryName)
            XCTAssertFalse(HintProvider.hint2(for: question).contains("Stockholm"))
        }
    }

    // MARK: CountryFunFacts data integrity

    func testEveryCountryHasAFunFact() {
        for country in CountryData.all {
            XCTAssertNotNil(CountryFunFacts.all[country.id], "Missing fun fact for \(country.name) (\(country.id))")
        }
    }

    func testNoFunFactNamesItsOwnCountryOrCapital() {
        for country in CountryData.all {
            guard let fact = CountryFunFacts.all[country.id] else { continue }
            XCTAssertFalse(fact.contains(country.name), "\(country.id)'s fun fact names the country itself: \(fact)")
            XCTAssertFalse(fact.contains(country.capital), "\(country.id)'s fun fact names its own capital: \(fact)")
        }
    }
}
