import Foundation

/// Which direction a Capitals question goes. Other modes always target `.countryName`.
enum AnswerTarget {
    case countryName
    case capitalName
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
            switch target {
            case .countryName: return "Which country has the capital \(country.capital)?"
            case .capitalName: return "What is the capital of \(country.name)?"
            }
        case .flags, .contours, .aerial:
            return "Which country is this?"
        }
    }

    var acceptableAnswers: [String] {
        switch target {
        case .countryName: return country.acceptableNameAnswers
        case .capitalName: return country.acceptableCapitalAnswers
        }
    }

    /// The canonical (non-alias) correct answer, shown when a question is missed.
    var primaryAnswer: String {
        switch target {
        case .countryName: return country.name
        case .capitalName: return country.capital
        }
    }
}
