import XCTest
@testable import GeoQuiz

final class BorderDataTests: XCTestCase {
    func testEveryCountryHasAnEntry() {
        for country in CountryData.all {
            XCTAssertNotNil(
                BorderData.neighbors[country.id],
                "Missing border entry for \(country.name) (\(country.id))"
            )
        }
    }

    func testKnownLandBordersArePresent() {
        XCTAssertTrue(BorderData.neighbors["FR"]?.contains("Germany") ?? false)
        XCTAssertTrue(BorderData.neighbors["US"]?.contains("Canada") ?? false)
        XCTAssertTrue(BorderData.neighbors["US"]?.contains("Mexico") ?? false)
        XCTAssertTrue(BorderData.neighbors["GB"]?.contains("Ireland") ?? false)
    }

    func testIslandNationsHaveNoLandBorders() {
        for code in ["AU", "JP", "NZ", "PH", "CY", "MT"] {
            XCTAssertEqual(BorderData.neighbors[code], [], "\(code) shouldn't have a land border")
        }
    }

    func testFranceDoesNotListDistantOverseasTerritoryNeighbors() {
        // French Guiana borders Brazil/Suriname, but "France borders Brazil" would read
        // as a mistake to a casual player — mainland-only adjacency should exclude it.
        let france = BorderData.neighbors["FR"] ?? []
        XCTAssertFalse(france.contains("Brazil"))
        XCTAssertFalse(france.contains("Suriname"))
    }

    func testChinaDoesNotListTaiwanOrItsOwnSpecialAdministrativeRegions() {
        // Taiwan is encoded with a non-standard subdivision-style ISO code in the source
        // data and has no actual land border with the mainland; Hong Kong/Macao are part
        // of China, not neighbors of it.
        let china = BorderData.neighbors["CN"] ?? []
        XCTAssertFalse(china.contains("Taiwan"))
        XCTAssertFalse(china.contains(where: { $0.contains("Hong Kong") }))
        XCTAssertFalse(china.contains(where: { $0.contains("Macao") }))
    }

    func testNoCountryListsItselfAsANeighbor() {
        for country in CountryData.all {
            XCTAssertFalse(BorderData.neighbors[country.id]?.contains(country.name) ?? false)
        }
    }
}
