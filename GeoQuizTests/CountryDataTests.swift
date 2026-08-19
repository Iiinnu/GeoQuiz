import XCTest
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
}
