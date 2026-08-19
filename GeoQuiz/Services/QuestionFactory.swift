import Foundation

/// Builds a session's question set from whichever modes the player picked.
/// Only implemented modes actually contribute questions today; unimplemented modes
/// are filtered out here so the picker can offer them without breaking the session.
enum QuestionFactory {
    static func makeSession(
        modes: Set<GameMode>,
        countries: [Country] = CountryData.all,
        questionCount: Int = 20
    ) -> [Question] {
        let usableModes = modes.filter(\.isImplemented)
        let modesToUse = usableModes.isEmpty ? [.capitals] : Array(usableModes)

        let shuffledCountries = countries.shuffled().prefix(questionCount)
        let questions = shuffledCountries.enumerated().map { index, country -> Question in
            let mode = modesToUse[index % modesToUse.count]
            let target: AnswerTarget = mode == .capitals
                ? (Bool.random() ? .countryName : .capitalName)
                : .countryName
            return Question(mode: mode, country: country, target: target)
        }
        return questions.shuffled()
    }
}
