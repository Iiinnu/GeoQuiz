import Foundation

enum GameMode: String, CaseIterable, Identifiable, Codable {
    case capitals
    case flags
    case contours
    case aerial

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .capitals: return "Capitals"
        case .flags: return "Flags"
        case .contours: return "Contours"
        case .aerial: return "Aerial"
        }
    }

    var subtitle: String {
        switch self {
        case .capitals: return "Type the capital, or the country"
        case .flags: return "Name the country from its flag"
        case .contours: return "Name the country from its outline"
        case .aerial: return "Name the country from a satellite view"
        }
    }

    var systemImageName: String {
        switch self {
        case .capitals: return "building.columns"
        case .flags: return "flag"
        case .contours: return "map"
        case .aerial: return "globe.americas"
        }
    }

    /// Capitals (Phase 1), Flags (Phase 2), and Contours (Phase 3) are built end-to-end;
    /// Aerial is shown but disabled until its asset pipeline exists.
    var isImplemented: Bool { self != .aerial }
}
