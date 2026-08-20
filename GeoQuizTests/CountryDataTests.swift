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
}
