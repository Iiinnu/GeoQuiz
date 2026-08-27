import XCTest
import UIKit
@testable import GeoQuiz

final class CountryDataTests: XCTestCase {
    func testDatasetSizeIsCuratedRange() {
        // Widened for the South America/Asia/Africa expansion (58 -> 76 countries).
        XCTAssertGreaterThanOrEqual(CountryData.all.count, 70)
        XCTAssertLessThanOrEqual(CountryData.all.count, 80)
    }

    func testIdsAreUnique() {
        let ids = CountryData.all.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count)
    }

    func testNoEmptyRequiredFields() {
        for country in CountryData.all {
            XCTAssertFalse(country.id.isEmpty)
            XCTAssertFalse(country.name.isEmpty)
            XCTAssertFalse(country.capital.isEmpty)
        }
    }

    func testAllRegionsRepresented() {
        let regions = Set(CountryData.all.map(\.region))
        XCTAssertEqual(regions, Set(Region.allCases))
    }

    func testEveryCountryHasAFlagAssetRefFollowingNamingConvention() {
        for country in CountryData.all {
            XCTAssertEqual(country.flagAssetRef, "flag_\(country.id)")
        }
    }

    func testFlagAssetsActuallyExistInTheBundle() {
        for country in CountryData.all {
            XCTAssertNotNil(
                UIImage(named: country.flagAssetRef!),
                "Missing flag asset '\(country.flagAssetRef!)' for \(country.name) — check Assets.xcassets"
            )
        }
    }

    func testEveryCountryHasAnAerialImageRefFollowingNamingConvention() {
        for country in CountryData.all {
            XCTAssertEqual(country.aerialImageRef, "aerial_\(country.id)")
        }
    }

    func testAerialImageAssetsActuallyExistInTheBundle() {
        for country in CountryData.all {
            XCTAssertNotNil(
                UIImage(named: country.aerialImageRef!),
                "Missing aerial asset '\(country.aerialImageRef!)' for \(country.name) — check Assets.xcassets"
            )
        }
    }

    func testEveryCountryHasAPlausiblePopulation() {
        for country in CountryData.all {
            XCTAssertGreaterThan(country.populationMillions, 0, "\(country.name) needs a real population figure")
            XCTAssertLessThan(country.populationMillions, 1_500, "\(country.name)'s population looks implausible")
        }
    }

    func testAerialCityDefaultsToTheCapitalUnlessOverridden() {
        for country in CountryData.all where !["ZA", "TZ"].contains(country.id) {
            XCTAssertEqual(country.resolvedAerialCityName, country.capital)
            XCTAssertEqual(country.resolvedAerialCityDescriptor, "the capital")
            XCTAssertEqual(country.acceptableAerialCityAnswers, country.acceptableCapitalAnswers)
        }
    }

    func testSouthAfricaAerialCityOverridesToCapeTown() {
        let southAfrica = CountryData.all.first { $0.id == "ZA" }!
        XCTAssertEqual(southAfrica.capital, "Pretoria", "Capitals mode should be unaffected by the Aerial override")
        XCTAssertEqual(southAfrica.resolvedAerialCityName, "Cape Town")
        XCTAssertTrue(southAfrica.acceptableAerialCityAnswers.contains("Cape Town"))
    }

    // MARK: - South America/Asia/Africa expansion (18 new countries)

    func testAllEighteenExpansionCountriesArePresent() {
        let expectedIDs: Set<String> = [
            "VE", "EC", "UY", "BO",
            "IR", "MY", "SG", "BD", "LK", "AE", "MN",
            "DZ", "ET", "GH", "TZ", "ZW", "SN", "CD",
        ]
        let actualIDs = Set(CountryData.all.map(\.id))
        XCTAssertTrue(expectedIDs.isSubset(of: actualIDs), "Missing expansion countries: \(expectedIDs.subtracting(actualIDs))")
    }

    func testExpansionCountriesHaveTheirRegionAssignedCorrectly() {
        let expectedRegions: [String: Region] = [
            "VE": .southAmerica, "EC": .southAmerica, "UY": .southAmerica, "BO": .southAmerica,
            "IR": .asia, "MY": .asia, "SG": .asia, "BD": .asia, "LK": .asia, "AE": .asia, "MN": .asia,
            "DZ": .africa, "ET": .africa, "GH": .africa, "TZ": .africa, "ZW": .africa, "SN": .africa, "CD": .africa,
        ]
        for (id, region) in expectedRegions {
            let country = CountryData.all.first { $0.id == id }
            XCTAssertEqual(country?.region, region, "\(id) should be in \(region)")
        }
    }

    func testBoliviaAcceptsBothItsCapitals() {
        let bolivia = CountryData.all.first { $0.id == "BO" }!
        XCTAssertEqual(bolivia.capital, "La Paz")
        XCTAssertTrue(bolivia.acceptableCapitalAnswers.contains("Sucre"))
    }

    func testSriLankaAcceptsItsOfficialCapitalAsAnAlias() {
        let sriLanka = CountryData.all.first { $0.id == "LK" }!
        XCTAssertEqual(sriLanka.capital, "Colombo")
        XCTAssertTrue(sriLanka.acceptableCapitalAnswers.contains("Sri Jayawardenepura Kotte"))
    }

    func testDemocraticRepublicOfCongoAcceptsCommonAlternateNames() {
        let drc = CountryData.all.first { $0.id == "CD" }!
        for alias in ["DR Congo", "DRC", "Congo-Kinshasa"] {
            XCTAssertTrue(drc.acceptableNameAnswers.contains(alias), "Missing alias '\(alias)' for DR Congo")
        }
    }

    func testTanzaniaAerialCityOverridesToDarEsSalaam() {
        let tanzania = CountryData.all.first { $0.id == "TZ" }!
        XCTAssertEqual(tanzania.capital, "Dodoma", "Capitals mode should be unaffected by the Aerial override")
        XCTAssertEqual(tanzania.resolvedAerialCityName, "Dar es Salaam")
        XCTAssertTrue(tanzania.acceptableAerialCityAnswers.contains("Dar es Salaam"))
        XCTAssertTrue(tanzania.acceptableCapitalAnswers.contains("Dar es Salaam"), "Dar es Salaam should also be accepted for the Capitals-mode question")
    }

    func testSingaporeCapitalEqualsCountryName() {
        // A real edge case, not a data bug: Singapore is a city-state.
        let singapore = CountryData.all.first { $0.id == "SG" }!
        XCTAssertEqual(singapore.capital, "Singapore")
        XCTAssertEqual(singapore.name, "Singapore")
    }
}
