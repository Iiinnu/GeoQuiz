import XCTest
@testable import GeoQuiz

final class ContourDataTests: XCTestCase {
    func testBundleLoadsSuccessfully() {
        XCTAssertFalse(ContourData.all.isEmpty, "Contours.json failed to load from the bundle")
    }

    func testEveryCountryHasContourData() {
        for country in CountryData.all {
            let rings = ContourData.all[country.borderShapeRef ?? ""]
            XCTAssertNotNil(rings, "Missing contour data for \(country.name) (\(country.id))")
            XCTAssertFalse(rings?.isEmpty ?? true, "\(country.name) has no rings")
        }
    }

    func testEveryRingHasAtLeastThreePoints() {
        for (code, rings) in ContourData.all {
            for ring in rings {
                XCTAssertGreaterThanOrEqual(ring.count, 3, "\(code) has a degenerate ring")
            }
        }
    }

    func testBorderShapeRefMatchesCountryId() {
        for country in CountryData.all {
            XCTAssertEqual(country.borderShapeRef, country.id)
        }
    }
}
