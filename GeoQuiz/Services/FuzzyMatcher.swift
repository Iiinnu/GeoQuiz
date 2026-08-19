import Foundation

/// Typo-tolerant answer checking. Threshold scales with word length so short answers
/// stay strict (no false positives like "USA" passing for "UGA") while longer answers
/// forgive a couple of typos. Tune `maxEditsAllowed` here as the single source of truth.
enum FuzzyMatcher {
    /// True if `input` is close enough to `target` to count as correct.
    static func matches(_ input: String, _ target: String) -> Bool {
        let a = normalize(input)
        let b = normalize(target)
        guard !a.isEmpty else { return false }
        if a == b { return true }
        let distance = levenshteinDistance(a, b)
        return distance <= maxEditsAllowed(for: b)
    }

    /// True if `input` matches any of `candidates`.
    static func matches(_ input: String, anyOf candidates: [String]) -> Bool {
        candidates.contains { matches(input, $0) }
    }

    /// Edit budget relative to the target's length. Tuned for typos, not guesses:
    /// - <=2 chars: exact match only (too easy to accidentally match a wrong short word)
    /// - 3-5 chars: 1 typo
    /// - 6-9 chars: 2 typos
    /// - 10+ chars: 3 typos
    static func maxEditsAllowed(for target: String) -> Int {
        switch target.count {
        case 0...2: return 0
        case 3...5: return 1
        case 6...9: return 2
        default: return 3
        }
    }

    /// Lowercases, strips diacritics, and collapses punctuation/whitespace so
    /// "Brasília" == "brasilia" and "Washington, D.C." == "washington dc".
    static func normalize(_ s: String) -> String {
        let folded = s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        let allowed = folded.unicodeScalars.map { scalar -> Character in
            (CharacterSet.alphanumerics.contains(scalar) || scalar == " ") ? Character(scalar) : " "
        }
        let collapsed = String(allowed)
            .split(separator: " ")
            .joined(separator: " ")
        return collapsed.trimmingCharacters(in: .whitespaces)
    }

    /// Classic Wagner-Fischer edit distance.
    static func levenshteinDistance(_ a: String, _ b: String) -> Int {
        let a = Array(a)
        let b = Array(b)
        if a.isEmpty { return b.count }
        if b.isEmpty { return a.count }

        var previousRow = Array(0...b.count)
        var currentRow = [Int](repeating: 0, count: b.count + 1)

        for i in 1...a.count {
            currentRow[0] = i
            for j in 1...b.count {
                let cost = a[i - 1] == b[j - 1] ? 0 : 1
                currentRow[j] = Swift.min(
                    previousRow[j] + 1,       // deletion
                    currentRow[j - 1] + 1,    // insertion
                    previousRow[j - 1] + cost // substitution
                )
            }
            previousRow = currentRow
        }
        return previousRow[b.count]
    }
}
