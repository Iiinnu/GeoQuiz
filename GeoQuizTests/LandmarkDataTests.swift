import XCTest
import UIKit
@testable import GeoQuiz

final class LandmarkDataTests: XCTestCase {
    func testBundleLoadsSuccessfully() {
        XCTAssertFalse(LandmarkData.all.isEmpty)
    }

    func testEveryCountryHasAtLeastOneLandmark() {
        for country in CountryData.all {
            let landmarks = LandmarkData.landmarks(forCountryID: country.id)
            XCTAssertFalse(landmarks.isEmpty, "Missing landmark(s) for \(country.name) (\(country.id))")
        }
    }

    func testNoDuplicateLandmarkIDs() {
        let ids = LandmarkData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "Landmark ids must be unique")
    }

    func testEveryLandmarkHasNonEmptyContent() {
        for landmark in LandmarkData.all {
            XCTAssertFalse(landmark.name.isEmpty, "\(landmark.id) has an empty name")
            XCTAssertFalse(landmark.eraFact.isEmpty, "\(landmark.id) has an empty eraFact")
            XCTAssertFalse(landmark.imageAssetRef.isEmpty, "\(landmark.id) has an empty imageAssetRef")
            XCTAssertFalse(landmark.attribution.isEmpty, "\(landmark.id) has an empty attribution")
        }
    }

    func testEveryLandmarkImageAssetExistsInTheBundle() {
        for landmark in LandmarkData.all {
            XCTAssertNotNil(
                UIImage(named: landmark.imageAssetRef),
                "Missing asset catalog image for \(landmark.imageAssetRef)"
            )
        }
    }

    func testEveryLandmarkCountryIDMatchesARealCountry() {
        let knownIDs = Set(CountryData.all.map(\.id))
        for landmark in LandmarkData.all {
            XCTAssertTrue(knownIDs.contains(landmark.countryID), "\(landmark.id) references unknown country \(landmark.countryID)")
        }
    }

    func testNoEraFactNamesItsOwnCountry() {
        for landmark in LandmarkData.all {
            guard let country = CountryData.all.first(where: { $0.id == landmark.countryID }) else { continue }
            XCTAssertFalse(
                landmark.eraFact.contains(country.name),
                "\(landmark.id)'s era fact names its own country: \(landmark.eraFact)"
            )
        }
    }

    // MARK: Multi-landmark countries

    /// Countries with more than one landmark, across both the original architectural/
    /// cultural set and the historic/pop-culture batch. Not a fixed 2-3 range any more —
    /// the historic/pop-culture batch deliberately weighted some countries (the US
    /// especially) far more heavily than others, same as Satellite mode's multi-city
    /// countries, with no visible grouping or cap.
    private static let multiLandmarkCountries: Set<String> = [
        "FR", "IT", "EG", "IN", "GR", "CN", "MX", "PE", "GB", "RU", "ES", "TR",
        "US", "DE", "JP", "BR", "TH", "VN", "PH", "ZA", "CD",
    ]

    func testMultiLandmarkCountriesHaveAtLeastTwoEntries() {
        for id in Self.multiLandmarkCountries {
            let count = LandmarkData.landmarks(forCountryID: id).count
            XCTAssertGreaterThanOrEqual(count, 2, "\(id) should have 2+ landmarks, has \(count)")
        }
    }

    func testUnitedStatesHasTheHeaviestHistoricPopCultureWeighting() {
        // A deliberate, approved skew (per the historic/pop-culture batch) rather than a
        // bug — locking it in as a floor so a future edit can't silently thin it back out.
        XCTAssertGreaterThanOrEqual(LandmarkData.landmarks(forCountryID: "US").count, 10)
    }

    func testSingleLandmarkCountriesHaveExactlyOneEntry() {
        for country in CountryData.all where !Self.multiLandmarkCountries.contains(country.id) {
            XCTAssertEqual(LandmarkData.landmarks(forCountryID: country.id).count, 1, "\(country.id) should have exactly one landmark")
        }
    }

    func testTotalLandmarkCountMatchesCoverageEntries() {
        XCTAssertEqual(LandmarkData.all.count, 119)
    }

    // MARK: answerType / answerText integrity (historic/pop-culture batch)

    func testCountryAnswerTypeEntriesHaveNoAnswerText() {
        for landmark in LandmarkData.all where landmark.answerType == .country {
            XCTAssertNil(landmark.answerText, "\(landmark.id) is answerType .country but has answerText set")
        }
    }

    func testNonCountryAnswerTypeEntriesHaveNonEmptyAnswerText() {
        for landmark in LandmarkData.all where landmark.answerType != .country {
            XCTAssertNotNil(landmark.answerText, "\(landmark.id) is answerType .\(landmark.answerType) but has no answerText")
            XCTAssertFalse(landmark.answerText?.isEmpty ?? true, "\(landmark.id) has an empty answerText")
        }
    }

    func testNoEraFactNamesItsOwnAnswerText() {
        // For city/state/placename entries, the era fact must not name the specific answer
        // itself (e.g. Dealey Plaza's fact must not say "Dallas") — same principle as never
        // naming the country for the original set.
        for landmark in LandmarkData.all {
            guard let answerText = landmark.answerText else { continue }
            XCTAssertFalse(
                landmark.eraFact.contains(answerText),
                "\(landmark.id)'s era fact names its own answer: \(landmark.eraFact)"
            )
        }
    }

    func testHistoricBatchEntriesArePresent() {
        let expectedIDs: Set<String> = [
            "GB_wembley", "GB_savilerow", "FR_pontalma", "US_dealey", "DE_brandenburg",
            "JP_genbaku", "BR_maracana", "US_911memorial", "US_edsullivan", "US_watergate",
            "PH_edsa", "US_graceland", "US_sunstudio",
            "UA_pripyat", "GB_runnymede", "VN_independencepalace", "CD_stadetata",
            "UG_entebbe", "TH_riverkwai", "IN_jallianwala", "CU_bayofpigs", "ZA_robbenisland",
            "US_alamo", "US_pearlharbor", "US_woodstock", "US_capecanaveral",
        ]
        let actualIDs = Set(LandmarkData.all.map(\.id))
        XCTAssertTrue(expectedIDs.isSubset(of: actualIDs), "Missing historic/pop-culture entries: \(expectedIDs.subtracting(actualIDs))")
    }
}
