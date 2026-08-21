import XCTest
import UIKit
@testable import GeoQuiz

final class CountryDataTests: XCTestCase {
    func testDatasetSizeIsCuratedRange() {
        XCTAssertGreaterThanOrEqual(CountryData.all.count, 50)
        XCTAssertLessThanOrEqual(CountryData.all.count, 60)
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
        for country in CountryData.all where country.id != "ZA" {
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
}
