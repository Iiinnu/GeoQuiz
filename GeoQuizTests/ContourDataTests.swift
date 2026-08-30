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

    // MARK: Neighbor rings (spatial context for Contours mode)

    func testNeighborRingsResolvesRealNeighborsToActualShapes() {
        // Sweden borders Finland and Norway, both in our dataset.
        let rings = ContourData.neighborRings(ofCountryID: "SE")
        XCTAssertFalse(rings.isEmpty, "expected Sweden to have neighbor rings from Finland/Norway")
    }

    func testNeighborRingsIsEmptyForIslandNations() {
        XCTAssertEqual(ContourData.neighborRings(ofCountryID: "AU"), [])
    }

    func testNeighborRingsSkipsRealNeighborsOutsideOurDataset() {
        // China has 14 real neighbors, but only a handful (India, Mongolia, Pakistan,
        // Russia, Vietnam) are in our 76-country set -- this shouldn't crash or include
        // placeholder data for the rest (Bhutan, Kazakhstan, etc.).
        let rings = ContourData.neighborRings(ofCountryID: "CN")
        XCTAssertFalse(rings.isEmpty)
    }

    // MARK: Projection correction (longitude scaled by each country's mean latitude)

    func testHighLatitudeCountriesAreNoLongerStretchedWide() {
        // Before the fix, Canada's raw (lon, -lat) bounding box was ~2.3x too wide
        // relative to its height because longitude compression at high latitude wasn't
        // corrected for. Canada's true shape is wider than tall, but nowhere near that
        // exaggerated -- this is a coarse regression guard, not an exact-ratio check.
        guard let rings = ContourData.all["CA"] else { return XCTFail("missing CA") }
        let points = rings.flatMap { $0 }
        let xs = points.map(\.x); let ys = points.map(\.y)
        let width = xs.max()! - xs.min()!
        let height = ys.max()! - ys.min()!
        XCTAssertLessThan(width / height, 2.0, "Canada still looks stretched -- projection correction may be missing")
    }

    func testFrenchGuianaIsExcludedFromFrancesShape() {
        // A real bug this data caught: French Guiana (~43 degrees of latitude from
        // mainland France) passed the area-ratio filter and made mainland France render
        // as a tiny fraction of a mostly-empty bounding box. Guard against regressing to
        // a multi-ring France.
        guard let rings = ContourData.all["FR"] else { return XCTFail("missing FR") }
        XCTAssertEqual(rings.count, 1, "France should be mainland-only; French Guiana should be filtered out")
    }
}
