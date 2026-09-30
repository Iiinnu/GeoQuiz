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

    // MARK: - Landmarks

    func testLandmarksQuestionsCarryALandmarkMatchingTheCountry() {
        let questions = QuestionFactory.makeSession(modes: [.landmarks], questionCount: 20)
        XCTAssertEqual(questions.count, 20)
        for question in questions {
            XCTAssertEqual(question.mode, .landmarks)
            guard let landmark = question.landmark else {
                return XCTFail("Landmarks question missing its landmark")
            }
            XCTAssertEqual(landmark.countryID, question.country.id)
            // Target follows the drawn landmark's own answerType, not a fixed mode-wide rule.
            XCTAssertEqual(question.target, landmark.answerType == .country ? .countryName : .landmarkPlace)
        }
    }

    func testNonLandmarksQuestionsCarryNoLandmark() {
        let questions = QuestionFactory.makeSession(modes: [.capitals], questionCount: 5)
        XCTAssertTrue(questions.allSatisfy { $0.landmark == nil })
    }

    // MARK: - Landmarks: answerType drives the target (historic/pop-culture batch)

    func testLandmarksQuestionUsesLandmarkPlaceTargetForNonCountryAnswerTypes() {
        // Draw many rounds and confirm at least one non-country-answer landmark (e.g. a
        // city like London/Dealey Plaza) turns up with the right target and answer text.
        var sawNonCountryTarget = false
        for _ in 0..<40 {
            let questions = QuestionFactory.makeSession(modes: [.landmarks], questionCount: 20)
            if let question = questions.first(where: { $0.landmark?.answerType != .country }) {
                sawNonCountryTarget = true
                XCTAssertEqual(question.target, .landmarkPlace)
                XCTAssertEqual(question.primaryAnswer, question.landmark?.answerText)
                break
            }
        }
        XCTAssertTrue(sawNonCountryTarget, "no non-country-answer Landmarks question turned up across 40 rounds")
    }

    // MARK: - promptText follows the drawn landmark's answerType

    private let sweden = Country(id: "SE", name: "Sweden", capital: "Stockholm", region: .europe, populationMillions: 10)

    func testPromptTextForCountryAnswerType() {
        let landmark = Landmark(id: "t", countryID: "SE", name: "Test", eraFact: "x", imageAssetRef: "x", attribution: "y")
        let question = Question(mode: .landmarks, country: sweden, target: .countryName, landmark: landmark)
        XCTAssertEqual(question.promptText, "Which country is this landmark in?")
    }

    func testPromptTextForCityAnswerType() {
        let landmark = Landmark(
            id: "t", countryID: "SE", name: "Test", eraFact: "x", imageAssetRef: "x", attribution: "y",
            answerType: .city, answerText: "London"
        )
        let question = Question(mode: .landmarks, country: sweden, target: .landmarkPlace, landmark: landmark)
        XCTAssertEqual(question.promptText, "Which city is this landmark in?")
    }

    func testPromptTextForStateAnswerType() {
        let landmark = Landmark(
            id: "t", countryID: "SE", name: "Test", eraFact: "x", imageAssetRef: "x", attribution: "y",
            answerType: .state, answerText: "Texas"
        )
        let question = Question(mode: .landmarks, country: sweden, target: .landmarkPlace, landmark: landmark)
        XCTAssertEqual(question.promptText, "Which state is this landmark in?")
    }

    func testPromptTextForPlacenameAnswerType() {
        let landmark = Landmark(
            id: "t", countryID: "SE", name: "Test", eraFact: "x", imageAssetRef: "x", attribution: "y",
            answerType: .placename, answerText: "Pearl Harbor"
        )
        let question = Question(mode: .landmarks, country: sweden, target: .landmarkPlace, landmark: landmark)
        XCTAssertEqual(question.promptText, "What is this place called?")
    }

    // MARK: - Aerial: multi-city countries (56-city expansion)

    func testAerialQuestionsCarryASatelliteCityMatchingTheCountry() {
        let questions = QuestionFactory.makeSession(modes: [.aerial], questionCount: 20)
        XCTAssertEqual(questions.count, 20)
        for question in questions {
            XCTAssertEqual(question.mode, .aerial)
            XCTAssertEqual(question.target, .aerialCityName)
            guard let satelliteCity = question.satelliteCity else {
                return XCTFail("Aerial question missing its satelliteCity")
            }
            XCTAssertEqual(satelliteCity.countryID, question.country.id)
            XCTAssertEqual(question.primaryAnswer, satelliteCity.cityName)
        }
    }

    func testAerialDrawsExtraCitiesNotJustTheDefault() {
        // Draw many rounds and confirm at least one non-default city (e.g. New York,
        // Marrakech) turns up -- there's no weighting toward the original single entry.
        var sawExtraCity = false
        for _ in 0..<40 {
            let questions = QuestionFactory.makeSession(modes: [.aerial], questionCount: 20)
            if questions.contains(where: { $0.satelliteCity?.id.hasSuffix("_default") == false }) {
                sawExtraCity = true
                break
            }
        }
        XCTAssertTrue(sawExtraCity, "no extra satellite city turned up across 40 rounds of 20 questions")
    }

    func testNonAerialQuestionsCarryNoSatelliteCity() {
        let questions = QuestionFactory.makeSession(modes: [.capitals], questionCount: 5)
        XCTAssertTrue(questions.allSatisfy { $0.satelliteCity == nil })
    }
}
