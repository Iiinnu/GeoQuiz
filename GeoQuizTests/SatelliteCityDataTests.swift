import XCTest
import UIKit
@testable import GeoQuiz

final class SatelliteCityDataTests: XCTestCase {
    func testBundleLoadsSuccessfully() {
        XCTAssertFalse(SatelliteCityData.all.isEmpty)
    }

    func testTotalExtraCityCountMatchesTheApprovedBatch() {
        XCTAssertEqual(SatelliteCityData.all.count, 56)
    }

    func testNoDuplicateCityIDs() {
        let ids = SatelliteCityData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "SatelliteCity ids must be unique")
    }

    func testEveryExtraCityHasNonEmptyContent() {
        for city in SatelliteCityData.all {
            XCTAssertFalse(city.cityName.isEmpty, "\(city.id) has an empty cityName")
            XCTAssertFalse(city.descriptor.isEmpty, "\(city.id) has an empty descriptor")
            XCTAssertFalse(city.imageAssetRef.isEmpty, "\(city.id) has an empty imageAssetRef")
        }
    }

    func testEveryExtraCityImageAssetExistsInTheBundle() {
        for city in SatelliteCityData.all {
            XCTAssertNotNil(
                UIImage(named: city.imageAssetRef),
                "Missing asset catalog image for \(city.imageAssetRef)"
            )
        }
    }

    func testEveryExtraCityCountryIDMatchesARealCountry() {
        let knownIDs = Set(CountryData.all.map(\.id))
        for city in SatelliteCityData.all {
            XCTAssertTrue(knownIDs.contains(city.countryID), "\(city.id) references unknown country \(city.countryID)")
        }
    }

    // None of these 56 are a capital, so Hint 1 should never call them "the capital".
    func testEveryExtraCityUsesAMajorCityDescriptorNotTheCapital() {
        for city in SatelliteCityData.all {
            XCTAssertEqual(city.descriptor, "a major city", "\(city.id) should use \"a major city\", not a capital-implying descriptor")
        }
    }

    // MARK: Country.allSatelliteCities / defaultSatelliteCity — purely additive

    func testEveryCountrysDefaultSatelliteCityMatchesItsExistingAerialFields() {
        for country in CountryData.all {
            let defaultCity = country.defaultSatelliteCity
            XCTAssertEqual(defaultCity.cityName, country.resolvedAerialCityName)
            XCTAssertEqual(defaultCity.descriptor, country.resolvedAerialCityDescriptor)
            XCTAssertEqual(defaultCity.imageAssetRef, country.aerialImageRef)
        }
    }

    func testAllSatelliteCitiesAlwaysIncludesTheDefaultFirst() {
        for country in CountryData.all {
            XCTAssertEqual(country.allSatelliteCities.first, country.defaultSatelliteCity)
        }
    }

    func testCountriesWithExtraCitiesHaveMoreThanOneSatelliteCity() {
        let expectedMultiCityCountries: Set<String> = [
            "EG", "MA", "ZA", "NG", "TZ",
            "CN", "IN", "JP", "ID", "TH", "VN", "KR", "TR", "IL", "AE",
            "FR", "DE", "IT", "ES", "GB", "RU", "CH", "GR", "PT", "AT", "PL",
            "US", "MX", "CA", "BR", "PE", "AU", "NZ",
        ]
        for id in expectedMultiCityCountries {
            let country = CountryData.all.first { $0.id == id }
            XCTAssertNotNil(country, "\(id) should exist in CountryData")
            XCTAssertGreaterThan(country?.allSatelliteCities.count ?? 0, 1, "\(id) should have more than 1 satellite city")
        }
    }

    func testCountriesWithoutExtraCitiesStillHaveExactlyOneSatelliteCity() {
        let expectedMultiCityCountries: Set<String> = [
            "EG", "MA", "ZA", "NG", "TZ",
            "CN", "IN", "JP", "ID", "TH", "VN", "KR", "TR", "IL", "AE",
            "FR", "DE", "IT", "ES", "GB", "RU", "CH", "GR", "PT", "AT", "PL",
            "US", "MX", "CA", "BR", "PE", "AU", "NZ",
        ]
        for country in CountryData.all where !expectedMultiCityCountries.contains(country.id) {
            XCTAssertEqual(country.allSatelliteCities.count, 1, "\(country.id) should still have exactly one satellite city")
        }
    }

    func testUnitedStatesHasFiveExtraCities() {
        XCTAssertEqual(SatelliteCityData.extraCities(forCountryID: "US").count, 5)
    }
}
