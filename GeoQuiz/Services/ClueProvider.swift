import Foundation

/// Generates clues from data already on `Country` — no per-country authoring needed.
/// Shared across all game modes, but the two entry points below deliberately differ by
/// mode: Capitals has no visual cue to lean on, so the hint gives the letter count and a
/// wrong guess gives the starting letter. Flags/Contours already show a picture, so the
/// hint stays light — just the region. Aerial's image is the least immediately
/// recognizable of the three, so its hint is richer (continent + country population)
/// even though it's still shown before any guess is made. A wrong guess then earns a
/// stronger clue that varies by mode: Contours (silhouette) names a real bordering
/// country, since the player is already looking at the shape and a neighbor helps place
/// it on the map; Flags/Aerial fall back to the starting letter (of the country, or of
/// the city for Aerial), as there's no map-shape context to build on.
enum ClueProvider {
    /// Clue shown when the player taps the on-demand hint button, before any guess.
    static func hintClue(for question: Question) -> String {
        switch question.mode {
        case .capitals: return letterCountClue(for: question)
        case .flags, .contours: return regionClue(for: question)
        case .aerial: return continentPopulationClue(for: question)
        }
    }

    /// Clue shown after an honest wrong guess.
    static func wrongGuessClue(for question: Question) -> String {
        switch question.mode {
        case .capitals, .flags, .aerial: return startsWithClue(for: question)
        case .contours: return bordersClue(for: question) ?? startsWithClue(for: question)
        }
    }

    static func regionClue(for question: Question) -> String {
        "It's in \(question.country.region.rawValue)."
    }

    static func letterCountClue(for question: Question) -> String {
        let letterCount = question.primaryAnswer.filter { $0.isLetter }.count
        return "It has \(letterCount) letters."
    }

    /// Aerial mode's pre-answer hint: continent plus country population, phrased around
    /// whatever the pictured city actually is (usually "the capital", occasionally
    /// something else — see `Country.aerialCityName`).
    static func continentPopulationClue(for question: Question) -> String {
        let continent = question.country.region.rawValue
        let population = question.country.populationMillions
        let descriptor = question.country.resolvedAerialCityDescriptor
        return "\(continent). This is \(descriptor) of the country with \(population) million people living there."
    }

    static func startsWithClue(for question: Question) -> String {
        let subject: String
        switch question.target {
        case .capitalName: subject = "The capital"
        case .aerialCityName: subject = "The city"
        case .countryName: subject = "The country"
        }
        return "\(subject) starts with '\(firstLetter(of: question))'."
    }

    /// Names a real bordering country. Returns nil for island nations with no land
    /// border (Australia, Japan, New Zealand, the Philippines, Cyprus, Malta) — callers
    /// fall back to `startsWithClue` for those.
    static func bordersClue(for question: Question) -> String? {
        guard let neighbor = BorderData.neighbors[question.country.id]?.randomElement() else {
            return nil
        }
        return "It shares a border with \(neighbor)."
    }

    private static func firstLetter(of question: Question) -> String {
        question.primaryAnswer.first.map(String.init)?.uppercased() ?? "?"
    }
}
