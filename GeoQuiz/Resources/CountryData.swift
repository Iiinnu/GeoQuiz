import Foundation

/// Curated Phase 1 dataset: G20 + EU members + a spread of other major countries per
/// continent (~58 total). All game modes read from this single list. Expanding to the
/// full ~195 UN member set later is additive — just append `Country` entries here.
enum CountryData {
    /// Flag asset names follow "flag_<id>" for every entry below, so it's derived here
    /// rather than repeated 58 times — see Assets.xcassets.
    static let all: [Country] = base.map { country in
        var country = country
        country.flagAssetRef = "flag_\(country.id)"
        return country
    }

    private static let base: [Country] = [
        // North America
        Country(id: "US", name: "United States", capital: "Washington, D.C.", region: .northAmerica,
                nameAliases: ["USA", "United States of America", "US", "America"],
                capitalAliases: ["Washington", "Washington DC", "DC"]),
        Country(id: "CA", name: "Canada", capital: "Ottawa", region: .northAmerica),
        Country(id: "MX", name: "Mexico", capital: "Mexico City", region: .northAmerica,
                capitalAliases: ["Ciudad de Mexico"]),

        // South America
        Country(id: "AR", name: "Argentina", capital: "Buenos Aires", region: .southAmerica),
        Country(id: "BR", name: "Brazil", capital: "Brasília", region: .southAmerica,
                capitalAliases: ["Brasilia"]),
        Country(id: "CL", name: "Chile", capital: "Santiago", region: .southAmerica),
        Country(id: "CO", name: "Colombia", capital: "Bogotá", region: .southAmerica,
                capitalAliases: ["Bogota"]),
        Country(id: "PE", name: "Peru", capital: "Lima", region: .southAmerica),

        // Europe
        Country(id: "FR", name: "France", capital: "Paris", region: .europe),
        Country(id: "DE", name: "Germany", capital: "Berlin", region: .europe),
        Country(id: "IT", name: "Italy", capital: "Rome", region: .europe, capitalAliases: ["Roma"]),
        Country(id: "GB", name: "United Kingdom", capital: "London", region: .europe,
                nameAliases: ["UK", "Britain", "Great Britain"]),
        Country(id: "RU", name: "Russia", capital: "Moscow", region: .europe,
                nameAliases: ["Russian Federation"], capitalAliases: ["Moskva"]),
        Country(id: "AT", name: "Austria", capital: "Vienna", region: .europe, capitalAliases: ["Wien"]),
        Country(id: "BE", name: "Belgium", capital: "Brussels", region: .europe),
        Country(id: "BG", name: "Bulgaria", capital: "Sofia", region: .europe),
        Country(id: "HR", name: "Croatia", capital: "Zagreb", region: .europe),
        Country(id: "CY", name: "Cyprus", capital: "Nicosia", region: .europe),
        Country(id: "CZ", name: "Czechia", capital: "Prague", region: .europe,
                nameAliases: ["Czech Republic"]),
        Country(id: "DK", name: "Denmark", capital: "Copenhagen", region: .europe),
        Country(id: "EE", name: "Estonia", capital: "Tallinn", region: .europe),
        Country(id: "FI", name: "Finland", capital: "Helsinki", region: .europe),
        Country(id: "GR", name: "Greece", capital: "Athens", region: .europe),
        Country(id: "HU", name: "Hungary", capital: "Budapest", region: .europe),
        Country(id: "IE", name: "Ireland", capital: "Dublin", region: .europe),
        Country(id: "LV", name: "Latvia", capital: "Riga", region: .europe),
        Country(id: "LT", name: "Lithuania", capital: "Vilnius", region: .europe),
        Country(id: "LU", name: "Luxembourg", capital: "Luxembourg City", region: .europe,
                capitalAliases: ["Luxembourg"]),
        Country(id: "MT", name: "Malta", capital: "Valletta", region: .europe),
        Country(id: "NL", name: "Netherlands", capital: "Amsterdam", region: .europe,
                nameAliases: ["Holland"]),
        Country(id: "PL", name: "Poland", capital: "Warsaw", region: .europe, capitalAliases: ["Warszawa"]),
        Country(id: "PT", name: "Portugal", capital: "Lisbon", region: .europe, capitalAliases: ["Lisboa"]),
        Country(id: "RO", name: "Romania", capital: "Bucharest", region: .europe),
        Country(id: "SK", name: "Slovakia", capital: "Bratislava", region: .europe),
        Country(id: "SI", name: "Slovenia", capital: "Ljubljana", region: .europe),
        Country(id: "ES", name: "Spain", capital: "Madrid", region: .europe),
        Country(id: "SE", name: "Sweden", capital: "Stockholm", region: .europe),
        Country(id: "NO", name: "Norway", capital: "Oslo", region: .europe),
        Country(id: "CH", name: "Switzerland", capital: "Bern", region: .europe, capitalAliases: ["Berne"]),

        // Asia
        Country(id: "CN", name: "China", capital: "Beijing", region: .asia, capitalAliases: ["Peking"]),
        Country(id: "IN", name: "India", capital: "New Delhi", region: .asia, capitalAliases: ["Delhi"]),
        Country(id: "ID", name: "Indonesia", capital: "Jakarta", region: .asia),
        Country(id: "JP", name: "Japan", capital: "Tokyo", region: .asia),
        Country(id: "SA", name: "Saudi Arabia", capital: "Riyadh", region: .asia),
        Country(id: "KR", name: "South Korea", capital: "Seoul", region: .asia,
                nameAliases: ["Korea, South", "Republic of Korea"]),
        Country(id: "TR", name: "Turkey", capital: "Ankara", region: .asia, nameAliases: ["Turkiye"]),
        Country(id: "TH", name: "Thailand", capital: "Bangkok", region: .asia),
        Country(id: "VN", name: "Vietnam", capital: "Hanoi", region: .asia),
        Country(id: "PH", name: "Philippines", capital: "Manila", region: .asia),
        Country(id: "PK", name: "Pakistan", capital: "Islamabad", region: .asia),
        Country(id: "IL", name: "Israel", capital: "Jerusalem", region: .asia),

        // Africa
        Country(id: "ZA", name: "South Africa", capital: "Pretoria", region: .africa,
                capitalAliases: ["Cape Town"]),
        Country(id: "EG", name: "Egypt", capital: "Cairo", region: .africa),
        Country(id: "NG", name: "Nigeria", capital: "Abuja", region: .africa),
        Country(id: "KE", name: "Kenya", capital: "Nairobi", region: .africa),
        Country(id: "MA", name: "Morocco", capital: "Rabat", region: .africa),

        // Oceania
        Country(id: "AU", name: "Australia", capital: "Canberra", region: .oceania),
        Country(id: "NZ", name: "New Zealand", capital: "Wellington", region: .oceania),
    ]
}
