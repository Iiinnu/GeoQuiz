import Foundation

/// Curated Phase 1 dataset: G20 + EU members + a spread of other major countries per
/// continent (~58 total). All game modes read from this single list. Expanding to the
/// full ~195 UN member set later is additive — just append `Country` entries here.
enum CountryData {
    /// Flag/aerial asset names follow "flag_<id>"/"aerial_<id>" and contour lookup keys
    /// are just `id` itself — all derived here rather than repeated 58 times. See
    /// Assets.xcassets and Contours.json.
    static let all: [Country] = base.map { country in
        var country = country
        country.flagAssetRef = "flag_\(country.id)"
        country.borderShapeRef = country.id
        country.aerialImageRef = "aerial_\(country.id)"
        return country
    }

    private static let base: [Country] = [
        // North America
        Country(id: "US", name: "United States", capital: "Washington, D.C.", region: .northAmerica, populationMillions: 328,
                nameAliases: ["USA", "United States of America", "US", "America"],
                capitalAliases: ["Washington", "Washington DC", "DC"]),
        Country(id: "CA", name: "Canada", capital: "Ottawa", region: .northAmerica, populationMillions: 38),
        Country(id: "MX", name: "Mexico", capital: "Mexico City", region: .northAmerica, populationMillions: 128,
                capitalAliases: ["Ciudad de Mexico"]),

        // South America
        Country(id: "AR", name: "Argentina", capital: "Buenos Aires", region: .southAmerica, populationMillions: 45),
        Country(id: "BR", name: "Brazil", capital: "Brasília", region: .southAmerica, populationMillions: 211,
                capitalAliases: ["Brasilia"]),
        Country(id: "CL", name: "Chile", capital: "Santiago", region: .southAmerica, populationMillions: 19),
        Country(id: "CO", name: "Colombia", capital: "Bogotá", region: .southAmerica, populationMillions: 50,
                capitalAliases: ["Bogota"]),
        Country(id: "PE", name: "Peru", capital: "Lima", region: .southAmerica, populationMillions: 33),

        // Europe
        Country(id: "FR", name: "France", capital: "Paris", region: .europe, populationMillions: 67),
        Country(id: "DE", name: "Germany", capital: "Berlin", region: .europe, populationMillions: 83),
        Country(id: "IT", name: "Italy", capital: "Rome", region: .europe, populationMillions: 60, capitalAliases: ["Roma"]),
        Country(id: "GB", name: "United Kingdom", capital: "London", region: .europe, populationMillions: 67,
                nameAliases: ["UK", "Britain", "Great Britain"]),
        Country(id: "RU", name: "Russia", capital: "Moscow", region: .europe, populationMillions: 144,
                nameAliases: ["Russian Federation"], capitalAliases: ["Moskva"]),
        Country(id: "AT", name: "Austria", capital: "Vienna", region: .europe, populationMillions: 9, capitalAliases: ["Wien"]),
        Country(id: "BE", name: "Belgium", capital: "Brussels", region: .europe, populationMillions: 11),
        Country(id: "BG", name: "Bulgaria", capital: "Sofia", region: .europe, populationMillions: 7),
        Country(id: "HR", name: "Croatia", capital: "Zagreb", region: .europe, populationMillions: 4),
        Country(id: "CY", name: "Cyprus", capital: "Nicosia", region: .europe, populationMillions: 1),
        Country(id: "CZ", name: "Czechia", capital: "Prague", region: .europe, populationMillions: 11,
                nameAliases: ["Czech Republic"]),
        Country(id: "DK", name: "Denmark", capital: "Copenhagen", region: .europe, populationMillions: 6),
        Country(id: "EE", name: "Estonia", capital: "Tallinn", region: .europe, populationMillions: 1),
        Country(id: "FI", name: "Finland", capital: "Helsinki", region: .europe, populationMillions: 6),
        Country(id: "GR", name: "Greece", capital: "Athens", region: .europe, populationMillions: 11),
        Country(id: "HU", name: "Hungary", capital: "Budapest", region: .europe, populationMillions: 10),
        Country(id: "IE", name: "Ireland", capital: "Dublin", region: .europe, populationMillions: 5),
        Country(id: "LV", name: "Latvia", capital: "Riga", region: .europe, populationMillions: 2),
        Country(id: "LT", name: "Lithuania", capital: "Vilnius", region: .europe, populationMillions: 3),
        Country(id: "LU", name: "Luxembourg", capital: "Luxembourg City", region: .europe, populationMillions: 1,
                capitalAliases: ["Luxembourg"]),
        Country(id: "MT", name: "Malta", capital: "Valletta", region: .europe, populationMillions: 1),
        Country(id: "NL", name: "Netherlands", capital: "Amsterdam", region: .europe, populationMillions: 17,
                nameAliases: ["Holland"]),
        Country(id: "PL", name: "Poland", capital: "Warsaw", region: .europe, populationMillions: 38, capitalAliases: ["Warszawa"]),
        Country(id: "PT", name: "Portugal", capital: "Lisbon", region: .europe, populationMillions: 10, capitalAliases: ["Lisboa"]),
        Country(id: "RO", name: "Romania", capital: "Bucharest", region: .europe, populationMillions: 19),
        Country(id: "SK", name: "Slovakia", capital: "Bratislava", region: .europe, populationMillions: 5),
        Country(id: "SI", name: "Slovenia", capital: "Ljubljana", region: .europe, populationMillions: 2),
        Country(id: "ES", name: "Spain", capital: "Madrid", region: .europe, populationMillions: 47),
        Country(id: "SE", name: "Sweden", capital: "Stockholm", region: .europe, populationMillions: 10),
        Country(id: "NO", name: "Norway", capital: "Oslo", region: .europe, populationMillions: 5),
        Country(id: "CH", name: "Switzerland", capital: "Bern", region: .europe, populationMillions: 9, capitalAliases: ["Berne"]),

        // Asia
        Country(id: "CN", name: "China", capital: "Beijing", region: .asia, populationMillions: 1398, capitalAliases: ["Peking"]),
        Country(id: "IN", name: "India", capital: "New Delhi", region: .asia, populationMillions: 1366, capitalAliases: ["Delhi"]),
        Country(id: "ID", name: "Indonesia", capital: "Jakarta", region: .asia, populationMillions: 271),
        Country(id: "JP", name: "Japan", capital: "Tokyo", region: .asia, populationMillions: 126),
        Country(id: "SA", name: "Saudi Arabia", capital: "Riyadh", region: .asia, populationMillions: 34),
        Country(id: "KR", name: "South Korea", capital: "Seoul", region: .asia, populationMillions: 52,
                nameAliases: ["Korea, South", "Republic of Korea"]),
        Country(id: "TR", name: "Turkey", capital: "Ankara", region: .asia, populationMillions: 83, nameAliases: ["Turkiye"]),
        Country(id: "TH", name: "Thailand", capital: "Bangkok", region: .asia, populationMillions: 70),
        Country(id: "VN", name: "Vietnam", capital: "Hanoi", region: .asia, populationMillions: 96),
        Country(id: "PH", name: "Philippines", capital: "Manila", region: .asia, populationMillions: 108),
        Country(id: "PK", name: "Pakistan", capital: "Islamabad", region: .asia, populationMillions: 217),
        Country(id: "IL", name: "Israel", capital: "Jerusalem", region: .asia, populationMillions: 9),

        // Africa
        // South Africa's Aerial-mode image is centered on Cape Town, not the capital
        // Pretoria — capitalAliases still lists Cape Town too, so Capitals mode is
        // unaffected and still expects Pretoria as its primary answer.
        Country(id: "ZA", name: "South Africa", capital: "Pretoria", region: .africa, populationMillions: 59,
                capitalAliases: ["Cape Town"], aerialCityName: "Cape Town", aerialCityDescriptor: "a major city"),
        Country(id: "EG", name: "Egypt", capital: "Cairo", region: .africa, populationMillions: 100),
        Country(id: "NG", name: "Nigeria", capital: "Abuja", region: .africa, populationMillions: 201),
        Country(id: "KE", name: "Kenya", capital: "Nairobi", region: .africa, populationMillions: 53),
        Country(id: "MA", name: "Morocco", capital: "Rabat", region: .africa, populationMillions: 36),

        // Oceania
        Country(id: "AU", name: "Australia", capital: "Canberra", region: .oceania, populationMillions: 25),
        Country(id: "NZ", name: "New Zealand", capital: "Wellington", region: .oceania, populationMillions: 5),
    ]
}
