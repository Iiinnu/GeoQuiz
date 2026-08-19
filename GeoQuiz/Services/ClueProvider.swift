import Foundation

/// Generates a clue from data already on `Country` — no per-country authoring needed.
/// Shared across all game modes: Capitals uses it today, Flags/Contours/Aerial (whose
/// answer is always the country name) can call the same `clue(forCountryName:)` path.
enum ClueProvider {
    static func clue(for question: Question) -> String {
        let answer = question.primaryAnswer
        let letterCount = answer.filter { $0.isLetter }.count
        let firstLetter = answer.first.map(String.init)?.uppercased() ?? "?"
        let subject = question.target == .capitalName ? "The capital" : "The country"

        return "\(subject) starts with '\(firstLetter)', has \(letterCount) letters, "
            + "and is in \(question.country.region.rawValue)."
    }
}
