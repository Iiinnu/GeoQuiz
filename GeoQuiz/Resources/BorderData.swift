import Foundation

/// Real land-border neighbors for each of our 58 countries, derived from
/// datasets/geo-countries boundary geometry (see the Phase 3 pipeline). Used by
/// ClueProvider for the Contours-mode wrong-guess clue. Deliberately excludes
/// non-sovereign entries (Hong Kong/Macao are part of China, not neighbors of it)
/// and a dataset quirk that would have called Taiwan a China border (they don't
/// share one) — see build_borders.py for the full reasoning. Countries with no land
/// border (island nations) simply have an empty list; ClueProvider falls back to the
/// starts-with clue for those.
enum BorderData {
    static let neighbors: [String: [String]] = [
        "AR": ["Bolivia", "Brazil", "Chile", "Paraguay", "Uruguay"],
        "AT": ["Czechia", "Germany", "Hungary", "Italy", "Liechtenstein", "Slovakia", "Slovenia", "Switzerland"],
        "AU": [],
        "BE": ["France", "Germany", "Luxembourg", "Netherlands"],
        "BG": ["Greece", "North Macedonia", "Serbia", "Romania", "Turkey"],
        "BR": ["Argentina", "Bolivia", "Colombia", "Guyana", "Paraguay", "Peru", "Suriname", "Uruguay", "Venezuela"],
        "CA": ["United States"],
        "CH": ["Austria", "France", "Germany", "Italy", "Liechtenstein"],
        "CL": ["Argentina", "Bolivia", "Peru"],
        "CN": ["Afghanistan", "Bhutan", "India", "Kazakhstan", "Kyrgyzstan", "Laos", "Mongolia", "Myanmar", "Nepal", "North Korea", "Pakistan", "Russia", "Tajikistan", "Vietnam"],
        "CO": ["Brazil", "Ecuador", "Panama", "Peru", "Venezuela"],
        "CY": [],
        "CZ": ["Austria", "Germany", "Poland", "Slovakia"],
        "DE": ["Austria", "Belgium", "Czechia", "Denmark", "France", "Luxembourg", "Netherlands", "Poland", "Switzerland"],
        "DK": ["Germany"],
        "EE": ["Latvia", "Russia"],
        "EG": ["Israel", "Libya", "Palestine", "Saudi Arabia", "Sudan"],
        "ES": ["Andorra", "France", "Gibraltar", "Morocco", "Portugal"],
        "FI": ["Norway", "Russia", "Sweden"],
        "FR": ["Andorra", "Belgium", "Germany", "Italy", "Luxembourg", "Monaco", "Spain", "Switzerland"],
        "GB": ["Ireland"],
        "GR": ["Albania", "Bulgaria", "North Macedonia", "Turkey"],
        "HR": ["Bosnia and Herzegovina", "Hungary", "Montenegro", "Serbia", "Slovenia"],
        "HU": ["Austria", "Croatia", "Serbia", "Romania", "Slovakia", "Slovenia", "Ukraine"],
        "ID": ["East Timor", "Malaysia"],
        "IE": ["United Kingdom"],
        "IL": ["Egypt", "Jordan", "Lebanon", "Palestine", "Syria"],
        "IN": ["Bangladesh", "Bhutan", "China", "Myanmar", "Nepal", "Pakistan"],
        "IT": ["Austria", "France", "Slovenia", "Switzerland"],
        "JP": [],
        "KE": ["Ethiopia", "Somalia", "South Sudan", "Uganda", "Tanzania"],
        "KR": ["North Korea"],
        "LT": ["Belarus", "Latvia", "Poland"],
        "LU": ["Belgium", "France", "Germany"],
        "LV": ["Belarus", "Estonia", "Lithuania", "Russia"],
        "MA": ["Algeria", "Mauritania", "Spain", "Western Sahara"],
        "MT": [],
        "MX": ["Belize", "Guatemala", "United States"],
        "NG": ["Benin", "Cameroon", "Niger"],
        "NL": ["Belgium", "Germany"],
        "NO": ["Finland", "Sweden"],
        "NZ": [],
        "PE": ["Bolivia", "Brazil", "Chile", "Colombia", "Ecuador"],
        "PH": [],
        "PK": ["Afghanistan", "China", "India", "Iran"],
        "PL": ["Belarus", "Czechia", "Germany", "Lithuania", "Slovakia", "Ukraine"],
        "PT": ["Spain"],
        "RO": ["Bulgaria", "Hungary", "Moldova", "Serbia", "Ukraine"],
        "RU": ["Azerbaijan", "Belarus", "China", "Estonia", "Finland", "Georgia", "Kazakhstan", "Latvia", "Mongolia", "Ukraine"],
        "SA": ["Egypt", "Iraq", "Jordan", "Kuwait", "Oman", "Qatar", "United Arab Emirates", "Yemen"],
        "SE": ["Finland", "Norway"],
        "SI": ["Austria", "Croatia", "Hungary", "Italy"],
        "SK": ["Austria", "Czechia", "Hungary", "Poland", "Ukraine"],
        "TH": ["Cambodia", "Laos", "Malaysia", "Myanmar"],
        "TR": ["Armenia", "Azerbaijan", "Bulgaria", "Georgia", "Greece", "Iran", "Iraq", "Syria"],
        "US": ["Canada", "Mexico"],
        "VN": ["Cambodia", "China", "Laos"],
        "ZA": ["Botswana", "Mozambique", "Namibia", "Zimbabwe", "Eswatini"],
    ]
}
