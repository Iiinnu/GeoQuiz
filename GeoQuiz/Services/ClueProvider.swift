import Foundation

/// Generates clues from data already on `Country` — no per-country authoring needed.
/// Shared across all game modes, and staged in two tiers so guessing wrong still teaches
/// you something beyond what the on-demand hint already gave away:
/// - `regionClue`: shown when the player asks for a hint before attempting an answer.
/// - `startsWithClue`: shown after an honest wrong guess, more specific than the region.
enum ClueProvider {
    static func regionClue(for question: Question) -> String {
        "It's in \(question.country.region.rawValue)."
    }

    static func startsWithClue(for question: Question) -> String {
        let answer = question.primaryAnswer
        let firstLetter = answer.first.map(String.init)?.uppercased() ?? "?"
        let subject = question.target == .capitalName ? "The capital" : "The country"
        return "\(subject) starts with '\(firstLetter)'."
    }
}
