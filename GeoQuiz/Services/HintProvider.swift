import Foundation

/// Generates the two-tier hint system shared by all 4 modes. Hint 1 is available before
/// any guess, kept simple/hard on purpose. Hint 2 is shown automatically after a wrong
/// guess and always repeats Hint 1's content plus more — a hand-picked geography/culture
/// fact about the country (see `CountryFunFacts`) and a starting letter — so a player who
/// skipped Hint 1 never loses out on that information, and Hint 2 is never accidentally
/// identical to Hint 1.
enum HintProvider {
    /// Shown when the player taps the on-demand hint button, before any guess.
    static func hint1(for question: Question) -> String {
        switch question.mode {
        case .capitals, .flags:
            // Region + population for both: Capitals has no visual to lean on, and Flags'
            // image already shows every visual detail of the flag itself, so a hint that
            // described the flag's colors/symbols would just restate what's on screen.
            return regionPopulationHint(for: question)
        case .contours:
            return regionBorderCountHint(for: question)
        case .aerial:
            return continentPopulationHint(for: question)
        }
    }

    /// Shown automatically after an honest wrong guess. Always Hint 1's content plus a fun
    /// fact and a starting letter.
    static func hint2(for question: Question) -> String {
        let fact = CountryFunFacts.all[question.country.id] ?? ""
        return [hint1(for: question), fact, startsWithHint(for: question)]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    static func regionPopulationHint(for question: Question) -> String {
        "\(question.country.region.rawValue). This country has a population of \(question.country.populationMillions) million."
    }

    /// For island nations (no land border), says so directly rather than "0 other
    /// countries" — that phrasing itself is a distinguishing fact.
    static func regionBorderCountHint(for question: Question) -> String {
        let region = question.country.region.rawValue
        let count = BorderData.neighbors[question.country.id]?.count ?? 0
        switch count {
        case 0: return "\(region). It doesn't share a land border with any other country."
        case 1: return "\(region). It shares a border with only one other country."
        default: return "\(region). It shares a border with \(count) other countries."
        }
    }

    /// Aerial mode's Hint 1: continent plus country population, phrased around whatever
    /// the pictured city actually is (usually "the capital", occasionally something else —
    /// see `Country.aerialCityName`). The population figure is attached directly to "a
    /// country", not left as a dangling "living there" that could be misread as describing
    /// the city itself.
    static func continentPopulationHint(for question: Question) -> String {
        let continent = question.country.region.rawValue
        let population = question.country.populationMillions
        let descriptor = question.country.resolvedAerialCityDescriptor
        return "\(continent). It's \(descriptor) of a country with \(population) million people."
    }

    static func startsWithHint(for question: Question) -> String {
        let subject: String
        switch question.target {
        case .capitalName: subject = "The capital"
        case .aerialCityName: subject = "The city"
        case .countryName: subject = "The country"
        }
        return "\(subject) starts with '\(firstLetter(of: question))'."
    }

    private static func firstLetter(of question: Question) -> String {
        question.primaryAnswer.first.map(String.init)?.uppercased() ?? "?"
    }
}
