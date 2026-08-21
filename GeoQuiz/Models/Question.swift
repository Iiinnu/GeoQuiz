import Foundation

/// Which direction a Capitals question goes, or what Aerial mode is asking about.
/// Flags/Contours always target `.countryName`.
enum AnswerTarget {
    case countryName
    case capitalName
    /// Aerial mode's answer: the city the satellite image is centered on (usually the
    /// capital, but not always — see `Country.aerialCityName`).
    case aerialCityName
}

/// One question in a session, mode-agnostic so future modes plug into the same flow.
struct Question: Identifiable {
    let id = UUID()
    let mode: GameMode
    let country: Country
    let target: AnswerTarget

    var promptText: String {
        switch mode {
        case .capitals:
            // target is always .countryName or .capitalName here (see QuestionFactory).
            return target == .capitalName
                ? "What is the capital of \(country.name)?"
                : "Which country has the capital \(country.capital)?"
        case .flags, .contours:
            return "Which country is this?"
        case .aerial:
            return "Which city is this?"
        }
    }

    var acceptableAnswers: [String] {
        switch target {
        case .countryName: return country.acceptableNameAnswers
        case .capitalName: return country.acceptableCapitalAnswers
        case .aerialCityName: return country.acceptableAerialCityAnswers
        }
    }

    /// The canonical (non-alias) correct answer, shown when a question is missed.
    var primaryAnswer: String {
        switch target {
        case .countryName: return country.name
        case .capitalName: return country.capital
        case .aerialCityName: return country.resolvedAerialCityName
        }
    }
}
