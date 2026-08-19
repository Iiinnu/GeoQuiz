import Foundation

/// Single source of truth for a country, shared by every game mode.
/// Later modes read `flagAssetRef` / `borderShapeRef` / `aerialImageRef` — they stay
/// optional in Phase 1 since only Capitals mode is implemented.
struct Country: Identifiable, Codable, Hashable {
    /// ISO 3166-1 alpha-2 code, e.g. "SE".
    let id: String
    let name: String
    let capital: String
    let region: Region

    /// Extra accepted spellings for the country name (e.g. "USA", "US", "America").
    let nameAliases: [String]
    /// Extra accepted spellings for the capital (e.g. "Washington", "DC").
    let capitalAliases: [String]

    var flagAssetRef: String?
    var borderShapeRef: String?
    var aerialImageRef: String?

    init(
        id: String,
        name: String,
        capital: String,
        region: Region,
        nameAliases: [String] = [],
        capitalAliases: [String] = [],
        flagAssetRef: String? = nil,
        borderShapeRef: String? = nil,
        aerialImageRef: String? = nil
    ) {
        self.id = id
        self.name = name
        self.capital = capital
        self.region = region
        self.nameAliases = nameAliases
        self.capitalAliases = capitalAliases
        self.flagAssetRef = flagAssetRef
        self.borderShapeRef = borderShapeRef
        self.aerialImageRef = aerialImageRef
    }

    /// All strings that should count as a correct answer when the target is the country name.
    var acceptableNameAnswers: [String] { [name] + nameAliases }
    /// All strings that should count as a correct answer when the target is the capital.
    var acceptableCapitalAnswers: [String] { [capital] + capitalAliases }
}
