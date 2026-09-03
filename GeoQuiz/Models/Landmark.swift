import Foundation

/// What a Landmark question actually asks the player to name. Most entries answer with
/// the country (the original architectural/cultural set); the historic/pop-culture batch
/// added a handful of entries better known by a more specific place.
enum LandmarkAnswerType: String, Codable, Hashable {
    case country
    case city
    case state
    case placename
}

/// One landmark photo for Landmarks mode. Most countries have exactly one; a handful with
/// especially rich architectural/cultural history (or, for the historic/pop-culture batch,
/// several notable events) have more (see `LandmarkData`) — pooled together as a single
/// set of possible questions per country, with no visible grouping or sub-category.
struct Landmark: Identifiable, Hashable {
    let id: String
    let countryID: String
    /// Shown only in the Acknowledgements attribution line, never as part of the question
    /// itself — naming it would give the answer away.
    let name: String
    /// Hint 1 content: a fact about the landmark's purpose or era, deliberately not a
    /// description of what's visible in the photo (the photo already shows that).
    let eraFact: String
    let imageAssetRef: String
    let attribution: String
    /// What the player is actually asked to name. Defaults to `.country`, matching every
    /// entry in the original architectural/cultural set.
    let answerType: LandmarkAnswerType
    /// The correct answer text when `answerType != .country` (e.g. "London", "Texas",
    /// "Pearl Harbor"). Always nil for `.country` entries, which instead reuse the
    /// question's `Country` (name + its existing aliases) exactly like every other mode.
    let answerText: String?
    /// Extra accepted spellings for `answerText`. Only meaningful when `answerText` is set.
    let answerAliases: [String]

    init(
        id: String,
        countryID: String,
        name: String,
        eraFact: String,
        imageAssetRef: String,
        attribution: String,
        answerType: LandmarkAnswerType = .country,
        answerText: String? = nil,
        answerAliases: [String] = []
    ) {
        self.id = id
        self.countryID = countryID
        self.name = name
        self.eraFact = eraFact
        self.imageAssetRef = imageAssetRef
        self.attribution = attribution
        self.answerType = answerType
        self.answerText = answerText
        self.answerAliases = answerAliases
    }

    /// All strings that should count as a correct answer when `answerType != .country`.
    var acceptablePlaceAnswers: [String] {
        guard let answerText else { return [] }
        return [answerText] + answerAliases
    }
}
