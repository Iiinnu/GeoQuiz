import Foundation

/// Builds a session's question set from whichever modes the player picked.
/// Only implemented modes actually contribute questions today; unimplemented modes
/// are filtered out here so the picker can offer them without breaking the session.
enum QuestionFactory {
    /// - Parameter excludedCountryIDs: per-mode countries to avoid repeating (already asked
    ///   in the current cycle — see `GameStatsStore`). If a mode doesn't have enough
    ///   unexcluded countries to fill its share of the round, the remainder is filled from
    ///   the full pool (still avoiding duplicates within this round) rather than coming up
    ///   short — exhausting the pool should never shrink a round.
    static func makeSession(
        modes: Set<GameMode>,
        countries: [Country] = CountryData.all,
        questionCount: Int = 20,
        excludedCountryIDs: [GameMode: Set<String>] = [:]
    ) -> [Question] {
        let usableModes = modes.filter(\.isImplemented)
        let modesToUse = usableModes.isEmpty ? [.capitals] : Array(usableModes)

        var countPerMode: [GameMode: Int] = [:]
        for index in 0..<questionCount {
            let mode = modesToUse[index % modesToUse.count]
            countPerMode[mode, default: 0] += 1
        }

        let questions = countPerMode.flatMap { mode, count -> [Question] in
            let selected = selectCountries(
                count: count,
                from: countries,
                excluding: excludedCountryIDs[mode] ?? []
            )
            return selected.map { country in
                let target: AnswerTarget
                switch mode {
                case .capitals: target = Bool.random() ? .countryName : .capitalName
                case .aerial: target = .aerialCityName
                case .flags, .contours: target = .countryName
                }
                return Question(mode: mode, country: country, target: target)
            }
        }
        return questions.shuffled()
    }

    /// Picks `count` distinct countries, preferring ones not in `excluded`. Falls back to
    /// already-seen countries (still without repeating one within this call) if the
    /// unexcluded pool runs out.
    private static func selectCountries(count: Int, from countries: [Country], excluding excluded: Set<String>) -> [Country] {
        let shuffled = countries.shuffled()
        let unseen = shuffled.filter { !excluded.contains($0.id) }
        guard unseen.count < count else {
            return Array(unseen.prefix(count))
        }
        let usedIDs = Set(unseen.map(\.id))
        let refill = shuffled.filter { !usedIDs.contains($0.id) }
        return unseen + refill.prefix(count - unseen.count)
    }
}
