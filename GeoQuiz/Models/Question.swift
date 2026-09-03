import Foundation

/// Which direction a Capitals question goes, or what Aerial mode is asking about.
/// Flags/Contours always target `.countryName`; Landmarks targets `.countryName` for most
/// entries and `.landmarkPlace` for the rest (see `Landmark.answerType`).
enum AnswerTarget {
    case countryName
    case capitalName
    /// Aerial mode's answer: the city the satellite image is centered on (usually the
    /// capital, but not always — see `Country.aerialCityName`).
    case aerialCityName
    /// Landmarks mode's answer for entries where the country itself isn't the best fit —
    /// a city, state, or place name instead (see `Landmark.answerType`/`answerText`).
    case landmarkPlace
}

/// One question in a session, mode-agnostic so future modes plug into the same flow.
struct Question: Identifiable {
    let id = UUID()
    let mode: GameMode
    let country: Country
    let target: AnswerTarget
    /// Set only for `.landmarks` questions — which of the country's landmark photos (it
    /// may have more than one, see `LandmarkData`) this particular question shows.
    let landmark: Landmark?

    init(mode: GameMode, country: Country, target: AnswerTarget, landmark: Landmark? = nil) {
        self.mode = mode
        self.country = country
        self.target = target
        self.landmark = landmark
    }

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
        case .landmarks:
            switch landmark?.answerType ?? .country {
            case .country: return "Which country is this landmark in?"
            case .city: return "Which city is this landmark in?"
            case .state: return "Which state is this landmark in?"
            case .placename: return "What is this place called?"
            }
        }
    }

    var acceptableAnswers: [String] {
        switch target {
        case .countryName: return country.acceptableNameAnswers
        case .capitalName: return country.acceptableCapitalAnswers
        case .aerialCityName: return country.acceptableAerialCityAnswers
        case .landmarkPlace: return landmark?.acceptablePlaceAnswers ?? []
        }
    }

    /// The canonical (non-alias) correct answer, shown when a question is missed.
    var primaryAnswer: String {
        switch target {
        case .countryName: return country.name
        case .capitalName: return country.capital
        case .aerialCityName: return country.resolvedAerialCityName
        case .landmarkPlace: return landmark?.answerText ?? ""
        }
    }
}
