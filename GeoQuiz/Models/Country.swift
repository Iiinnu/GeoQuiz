import Foundation

/// Single source of truth for a country, shared by every game mode.
struct Country: Identifiable, Codable, Hashable {
    /// ISO 3166-1 alpha-2 code, e.g. "SE".
    let id: String
    let name: String
    let capital: String
    let region: Region
    /// Rounded to the nearest million — used by Aerial mode's pre-answer hint.
    let populationMillions: Int

    /// Extra accepted spellings for the country name (e.g. "USA", "US", "America").
    let nameAliases: [String]
    /// Extra accepted spellings for the capital (e.g. "Washington", "DC").
    let capitalAliases: [String]

    /// The city Aerial mode's satellite image is centered on, when it isn't the capital
    /// (e.g. Cape Town for South Africa, whose capital is Pretoria) — nil means "use the
    /// capital", true for 57 of our 58 countries. Read `resolvedAerialCityName` /
    /// `resolvedAerialCityDescriptor` / `acceptableAerialCityAnswers` rather than these
    /// raw fields directly.
    let aerialCityName: String?
    /// How the pre-answer hint refers to the city, e.g. "the capital" or "a major city".
    /// nil means "the capital" (matches the nil-aerialCityName default).
    let aerialCityDescriptor: String?
    /// Extra accepted spellings for `aerialCityName`. Only meaningful when
    /// `aerialCityName` is set — otherwise answers already fall back to
    /// `acceptableCapitalAnswers`, aliases included.
    let aerialCityAliases: [String]

    var flagAssetRef: String?
    var borderShapeRef: String?
    var aerialImageRef: String?

    init(
        id: String,
        name: String,
        capital: String,
        region: Region,
        populationMillions: Int,
        nameAliases: [String] = [],
        capitalAliases: [String] = [],
        aerialCityName: String? = nil,
        aerialCityDescriptor: String? = nil,
        aerialCityAliases: [String] = [],
        flagAssetRef: String? = nil,
        borderShapeRef: String? = nil,
        aerialImageRef: String? = nil
    ) {
        self.id = id
        self.name = name
        self.capital = capital
        self.region = region
        self.populationMillions = populationMillions
        self.nameAliases = nameAliases
        self.capitalAliases = capitalAliases
        self.aerialCityName = aerialCityName
        self.aerialCityDescriptor = aerialCityDescriptor
        self.aerialCityAliases = aerialCityAliases
        self.flagAssetRef = flagAssetRef
        self.borderShapeRef = borderShapeRef
        self.aerialImageRef = aerialImageRef
    }

    /// All strings that should count as a correct answer when the target is the country name.
    var acceptableNameAnswers: [String] { [name] + nameAliases }
    /// All strings that should count as a correct answer when the target is the capital.
    var acceptableCapitalAnswers: [String] { [capital] + capitalAliases }

    /// The city Aerial mode asks about — the capital unless overridden.
    var resolvedAerialCityName: String { aerialCityName ?? capital }
    /// How the pre-answer hint refers to that city.
    var resolvedAerialCityDescriptor: String { aerialCityDescriptor ?? "the capital" }
    /// All strings that should count as a correct answer for Aerial mode.
    var acceptableAerialCityAnswers: [String] {
        guard let aerialCityName else { return acceptableCapitalAnswers }
        return [aerialCityName] + aerialCityAliases
    }
}
