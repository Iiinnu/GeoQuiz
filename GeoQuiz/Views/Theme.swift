import SwiftUI

/// Shared app-wide color palette — muted forest green on light, neutral backgrounds.
/// The app pins `.preferredColorScheme(.light)` in `GeoQuizApp`, so these are plain
/// values rather than dynamic/dark-mode-aware colors.
enum Theme {
    /// Mirrors the AccentColor asset; kept as a plain value too for call sites that
    /// want it directly rather than relying on the system tint.
    static let accent = Color(red: 0.294, green: 0.420, blue: 0.306)
    static let background = Color(red: 0.965, green: 0.961, blue: 0.937)
    static let card = Color(red: 0.910, green: 0.929, blue: 0.890)
    /// Muted amber used for the hint/clue banner — decorative "here's some help"
    /// signal, distinct from both the accent green and the correct/wrong feedback
    /// colors so it can't be confused with either.
    static let hint = Color(red: 0.72, green: 0.58, blue: 0.20)
}
