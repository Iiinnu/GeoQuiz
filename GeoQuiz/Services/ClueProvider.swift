import Foundation

/// Generates clues from data already on `Country` — no per-country authoring needed.
/// Shared across all game modes, but the two entry points below deliberately differ by
/// mode: Capitals has no visual cue to lean on, so both the on-demand hint and a wrong
/// guess give the same fuller clue. Image-based modes (Flags today; Contours/Aerial
/// later) already show a picture, so the hint stays light — just the region — and only
/// a wrong guess earns the more specific starting letter.
enum ClueProvider {
    /// Clue shown when the player taps the on-demand hint button, before any guess.
    static func hintClue(for question: Question) -> String {
        switch question.mode {
        case .capitals: return combinedClue(for: question)
        case .flags, .contours, .aerial: return regionClue(for: question)
        }
    }

    /// Clue shown after an honest wrong guess.
    static func wrongGuessClue(for question: Question) -> String {
        switch question.mode {
        case .capitals: return combinedClue(for: question)
        case .flags, .contours, .aerial: return startsWithClue(for: question)
        }
    }

    static func regionClue(for question: Question) -> String {
        "It's in \(question.country.region.rawValue)."
    }

    static func startsWithClue(for question: Question) -> String {
        let subject = question.target == .capitalName ? "The capital" : "The country"
        return "\(subject) starts with '\(firstLetter(of: question))'."
    }

    static func combinedClue(for question: Question) -> String {
        let answer = question.primaryAnswer
        let letterCount = answer.filter { $0.isLetter }.count
        let subject = question.target == .capitalName ? "The capital" : "The country"

        return "\(subject) starts with '\(firstLetter(of: question))', has \(letterCount) letters, "
            + "and is in \(question.country.region.rawValue)."
    }

    private static func firstLetter(of question: Question) -> String {
        question.primaryAnswer.first.map(String.init)?.uppercased() ?? "?"
    }
}
