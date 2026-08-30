import Foundation
import CoreGraphics

/// Loads the bundled country-outline data (see Contours.json) once and caches it. Each
/// entry is a flat list of rings, already north-up and longitude-corrected (each
/// country's longitude is scaled by cos(its own mean latitude) at generation time, so
/// high-latitude countries like Canada or Russia render at their true proportions
/// instead of stretched ~2x too wide) — see `ContourShapeTests` and the build script
/// referenced in THIRD_PARTY_LICENSES.md. `ContourShape` fits rings to whatever rect
/// it's given, preserving aspect ratio, so no further scaling is needed here.
enum ContourData {
    static let all: [String: [[CGPoint]]] = load()

    private static func load() -> [String: [[CGPoint]]] {
        guard let url = Bundle.main.url(forResource: "Contours", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let raw = try? JSONDecoder().decode([String: [[[Double]]]].self, from: data)
        else {
            return [:]
        }
        return raw.mapValues { rings in
            rings.map { ring in ring.map { CGPoint(x: $0[0], y: $0[1]) } }
        }
    }

    /// Real neighboring countries' contour rings for `countryID`, resolved from
    /// `BorderData`'s neighbor names to `CountryData` entries we actually have contour
    /// data for. A real-world neighbor outside our 76-country set is silently skipped —
    /// there's no shape to show for it. Flattened to one list since callers only need
    /// "everything to draw as a thin outline", not which ring belongs to which neighbor.
    static func neighborRings(ofCountryID countryID: String) -> [[CGPoint]] {
        let neighborNames = BorderData.neighbors[countryID] ?? []
        let neighborIDs = neighborNames.compactMap { name in
            CountryData.all.first { $0.name == name }?.id
        }
        return neighborIDs.flatMap { all[$0] ?? [] }
    }
}
