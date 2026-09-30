import Foundation

/// Extra Aerial-mode cities layered on top of every country's existing single default
/// entry (see `Country.defaultSatelliteCity`/`allSatelliteCities`) — purely additive, chosen
/// for being visually distinctive from directly overhead (a coastline, river mouth, grid
/// pattern, or landmark visible in a satellite crop), same spirit as Landmarks' multi-entry
/// countries. Every entry here uses "a major city" for Hint 1's descriptor, since none of
/// them are a country's capital.
enum SatelliteCityData {
    static func extraCities(forCountryID id: String) -> [SatelliteCity] {
        all.filter { $0.countryID == id }
    }

    static let all: [SatelliteCity] = [
        // Africa
        SatelliteCity(id: "EG_alexandria", countryID: "EG", cityName: "Alexandria", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_EG_alexandria"),
        SatelliteCity(id: "EG_luxor", countryID: "EG", cityName: "Luxor", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_EG_luxor"),
        SatelliteCity(id: "MA_casablanca", countryID: "MA", cityName: "Casablanca", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_MA_casablanca"),
        SatelliteCity(id: "MA_marrakech", countryID: "MA", cityName: "Marrakech", cityAliases: ["Marrakesh"], descriptor: "a major city", imageAssetRef: "aerial_MA_marrakech"),
        SatelliteCity(id: "ZA_johannesburg", countryID: "ZA", cityName: "Johannesburg", cityAliases: ["Joburg"], descriptor: "a major city", imageAssetRef: "aerial_ZA_johannesburg"),
        SatelliteCity(id: "NG_lagos", countryID: "NG", cityName: "Lagos", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_NG_lagos"),
        SatelliteCity(id: "TZ_zanzibar", countryID: "TZ", cityName: "Zanzibar City", cityAliases: ["Zanzibar"], descriptor: "a major city", imageAssetRef: "aerial_TZ_zanzibar"),

        // Asia
        SatelliteCity(id: "CN_shanghai", countryID: "CN", cityName: "Shanghai", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_CN_shanghai"),
        SatelliteCity(id: "CN_hongkong", countryID: "CN", cityName: "Hong Kong", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_CN_hongkong"),
        SatelliteCity(id: "IN_mumbai", countryID: "IN", cityName: "Mumbai", cityAliases: ["Bombay"], descriptor: "a major city", imageAssetRef: "aerial_IN_mumbai"),
        SatelliteCity(id: "IN_agra", countryID: "IN", cityName: "Agra", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_IN_agra"),
        SatelliteCity(id: "JP_osaka", countryID: "JP", cityName: "Osaka", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_JP_osaka"),
        SatelliteCity(id: "JP_kyoto", countryID: "JP", cityName: "Kyoto", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_JP_kyoto"),
        SatelliteCity(id: "ID_bali", countryID: "ID", cityName: "Bali", cityAliases: ["Denpasar"], descriptor: "a major city", imageAssetRef: "aerial_ID_bali"),
        SatelliteCity(id: "TH_phuket", countryID: "TH", cityName: "Phuket", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_TH_phuket"),
        SatelliteCity(id: "TH_chiangmai", countryID: "TH", cityName: "Chiang Mai", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_TH_chiangmai"),
        SatelliteCity(id: "VN_hcmc", countryID: "VN", cityName: "Ho Chi Minh City", cityAliases: ["Saigon"], descriptor: "a major city", imageAssetRef: "aerial_VN_hcmc"),
        SatelliteCity(id: "KR_busan", countryID: "KR", cityName: "Busan", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_KR_busan"),
        SatelliteCity(id: "TR_istanbul", countryID: "TR", cityName: "Istanbul", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_TR_istanbul"),
        SatelliteCity(id: "IL_telaviv", countryID: "IL", cityName: "Tel Aviv", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_IL_telaviv"),
        SatelliteCity(id: "AE_dubai", countryID: "AE", cityName: "Dubai", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_AE_dubai"),

        // Europe
        SatelliteCity(id: "FR_marseille", countryID: "FR", cityName: "Marseille", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_FR_marseille"),
        SatelliteCity(id: "FR_nice", countryID: "FR", cityName: "Nice", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_FR_nice"),
        SatelliteCity(id: "DE_munich", countryID: "DE", cityName: "Munich", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_DE_munich"),
        SatelliteCity(id: "DE_hamburg", countryID: "DE", cityName: "Hamburg", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_DE_hamburg"),
        SatelliteCity(id: "DE_frankfurt", countryID: "DE", cityName: "Frankfurt", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_DE_frankfurt"),
        SatelliteCity(id: "IT_milan", countryID: "IT", cityName: "Milan", cityAliases: ["Milano"], descriptor: "a major city", imageAssetRef: "aerial_IT_milan"),
        SatelliteCity(id: "IT_venice", countryID: "IT", cityName: "Venice", cityAliases: ["Venezia"], descriptor: "a major city", imageAssetRef: "aerial_IT_venice"),
        SatelliteCity(id: "IT_naples", countryID: "IT", cityName: "Naples", cityAliases: ["Napoli"], descriptor: "a major city", imageAssetRef: "aerial_IT_naples"),
        SatelliteCity(id: "IT_florence", countryID: "IT", cityName: "Florence", cityAliases: ["Firenze"], descriptor: "a major city", imageAssetRef: "aerial_IT_florence"),
        SatelliteCity(id: "ES_barcelona", countryID: "ES", cityName: "Barcelona", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_ES_barcelona"),
        SatelliteCity(id: "ES_seville", countryID: "ES", cityName: "Seville", cityAliases: ["Sevilla"], descriptor: "a major city", imageAssetRef: "aerial_ES_seville"),
        SatelliteCity(id: "GB_edinburgh", countryID: "GB", cityName: "Edinburgh", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_GB_edinburgh"),
        SatelliteCity(id: "GB_manchester", countryID: "GB", cityName: "Manchester", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_GB_manchester"),
        SatelliteCity(id: "GB_liverpool", countryID: "GB", cityName: "Liverpool", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_GB_liverpool"),
        SatelliteCity(id: "RU_stpetersburg", countryID: "RU", cityName: "St. Petersburg", cityAliases: ["Saint Petersburg"], descriptor: "a major city", imageAssetRef: "aerial_RU_stpetersburg"),
        SatelliteCity(id: "CH_zurich", countryID: "CH", cityName: "Zurich", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_CH_zurich"),
        SatelliteCity(id: "CH_geneva", countryID: "CH", cityName: "Geneva", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_CH_geneva"),
        SatelliteCity(id: "GR_santorini", countryID: "GR", cityName: "Santorini", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_GR_santorini"),
        SatelliteCity(id: "PT_porto", countryID: "PT", cityName: "Porto", cityAliases: ["Oporto"], descriptor: "a major city", imageAssetRef: "aerial_PT_porto"),
        SatelliteCity(id: "AT_salzburg", countryID: "AT", cityName: "Salzburg", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_AT_salzburg"),
        SatelliteCity(id: "PL_krakow", countryID: "PL", cityName: "Krakow", cityAliases: ["Kraków", "Cracow"], descriptor: "a major city", imageAssetRef: "aerial_PL_krakow"),

        // North America
        SatelliteCity(id: "US_nyc", countryID: "US", cityName: "New York City", cityAliases: ["New York", "NYC"], descriptor: "a major city", imageAssetRef: "aerial_US_nyc"),
        SatelliteCity(id: "US_la", countryID: "US", cityName: "Los Angeles", cityAliases: ["LA"], descriptor: "a major city", imageAssetRef: "aerial_US_la"),
        SatelliteCity(id: "US_chicago", countryID: "US", cityName: "Chicago", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_US_chicago"),
        SatelliteCity(id: "US_miami", countryID: "US", cityName: "Miami", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_US_miami"),
        SatelliteCity(id: "US_vegas", countryID: "US", cityName: "Las Vegas", cityAliases: ["Vegas"], descriptor: "a major city", imageAssetRef: "aerial_US_vegas"),
        SatelliteCity(id: "MX_cancun", countryID: "MX", cityName: "Cancún", cityAliases: ["Cancun"], descriptor: "a major city", imageAssetRef: "aerial_MX_cancun"),
        SatelliteCity(id: "CA_toronto", countryID: "CA", cityName: "Toronto", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_CA_toronto"),
        SatelliteCity(id: "CA_vancouver", countryID: "CA", cityName: "Vancouver", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_CA_vancouver"),

        // South America
        SatelliteCity(id: "BR_rio", countryID: "BR", cityName: "Rio de Janeiro", cityAliases: ["Rio"], descriptor: "a major city", imageAssetRef: "aerial_BR_rio"),
        SatelliteCity(id: "BR_saopaulo", countryID: "BR", cityName: "São Paulo", cityAliases: ["Sao Paulo"], descriptor: "a major city", imageAssetRef: "aerial_BR_saopaulo"),
        SatelliteCity(id: "PE_cusco", countryID: "PE", cityName: "Cusco", cityAliases: ["Cuzco"], descriptor: "a major city", imageAssetRef: "aerial_PE_cusco"),

        // Oceania
        SatelliteCity(id: "AU_sydney", countryID: "AU", cityName: "Sydney", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_AU_sydney"),
        SatelliteCity(id: "AU_melbourne", countryID: "AU", cityName: "Melbourne", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_AU_melbourne"),
        SatelliteCity(id: "NZ_auckland", countryID: "NZ", cityName: "Auckland", cityAliases: [], descriptor: "a major city", imageAssetRef: "aerial_NZ_auckland"),
    ]
}
