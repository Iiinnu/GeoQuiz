import Foundation

/// One satellite/aerial photo for Aerial mode. Every country has at least one (its existing
/// default — the capital, or a `Country.aerialCityName` override like Cape Town/Dar es
/// Salaam); a batch of major, visually distinctive cities added on top gives some countries
/// several — pooled together per country with no visible grouping, same pattern as
/// Landmarks' multi-entry countries.
struct SatelliteCity: Identifiable, Hashable {
    let id: String
    let countryID: String
    let cityName: String
    /// Extra accepted spellings for `cityName`.
    let cityAliases: [String]
    /// How Hint 1 refers to this city, e.g. "the capital" or "a major city".
    let descriptor: String
    let imageAssetRef: String
}

extension Country {
    /// This country's existing single Aerial-mode entry (capital, or its
    /// `aerialCityName` override), represented as a `SatelliteCity` so it can be pooled
    /// alongside any extra cities from `SatelliteCityData` — untouched and unmodified,
    /// just reshaped for the shared multi-city picking logic in `QuestionFactory`.
    var defaultSatelliteCity: SatelliteCity {
        SatelliteCity(
            id: "\(id)_default",
            countryID: id,
            cityName: resolvedAerialCityName,
            cityAliases: aerialCityAliases,
            descriptor: resolvedAerialCityDescriptor,
            imageAssetRef: aerialImageRef ?? "aerial_\(id)"
        )
    }

    /// Every satellite city available for this country — the existing default entry plus
    /// any extras from `SatelliteCityData`. `QuestionFactory` draws one of these at random
    /// per Aerial-mode question; no entry (including the default) is weighted above another.
    var allSatelliteCities: [SatelliteCity] {
        [defaultSatelliteCity] + SatelliteCityData.extraCities(forCountryID: id)
    }
}
