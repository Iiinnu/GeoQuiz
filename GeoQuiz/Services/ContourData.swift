import Foundation
import CoreGraphics

/// Loads the bundled country-outline data (see Contours.json) once and caches it. Each
/// entry is a flat list of rings — already north-up, in the source data's natural
/// (unscaled) coordinate space. `ContourShape` fits them to whatever rect it's given,
/// preserving aspect ratio, so no pre-normalization is needed here.
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
}
