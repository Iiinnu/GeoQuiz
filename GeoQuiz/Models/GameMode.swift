import Foundation

enum GameMode: String, CaseIterable, Identifiable, Codable {
    case capitals
    case flags
    case contours
    case aerial
    case landmarks

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .capitals: return "Capitals"
        case .flags: return "Flags"
        case .contours: return "Contours"
        case .aerial: return "Aerial"
        case .landmarks: return "Landmarks"
        }
    }

    var subtitle: String {
        switch self {
        case .capitals: return "Type the capital, or the country"
        case .flags: return "Name the country from its flag"
        case .contours: return "Name the country from its outline"
        case .aerial: return "Name the city from a satellite view"
        case .landmarks: return "Name the country from a famous landmark"
        }
    }

    var systemImageName: String {
        switch self {
        case .capitals: return "building.columns"
        case .flags: return "flag"
        case .contours: return "map"
        case .aerial: return "globe.americas"
        case .landmarks: return "building.2"
        }
    }

    /// All five modes are built end-to-end as of Phase 5 (Landmarks).
    var isImplemented: Bool { true }
}
