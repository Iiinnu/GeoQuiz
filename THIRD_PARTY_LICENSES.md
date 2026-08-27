# Third-party assets

## Flag images

The flag images in `GeoQuiz/Resources/Assets.xcassets` (`flag_*.imageset`) are
converted from SVGs in [flag-icons](https://github.com/lipis/flag-icons) by
Panayiotis Lipiridis, used under the MIT License:

```
The MIT License (MIT)

Copyright (c) 2013 Panayiotis Lipiridis

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Country border outlines

`GeoQuiz/Resources/Contours.json` is derived from `countries.geojson` in
[datasets/geo-countries](https://github.com/datasets/geo-countries) (boundary data
sourced from Natural Earth), used under the Open Data Commons Public Domain Dedication
and License (PDDL) — public domain, no attribution required. Coordinates were filtered
to each country's significant landmasses, simplified, and normalized; see
`GeoQuiz/Services/ContourData.swift` and `GeoQuiz/Views/ContourShape.swift`.

## Country land-border data

`GeoQuiz/Resources/BorderData.swift` (used for the Contours-mode wrong-guess clue) is
also derived from the same `countries.geojson` — border adjacency was computed
geometrically from the boundary polygons rather than sourced from a separate dataset.
Same PDDL terms as above apply.

## Aerial (satellite) images

The images in `GeoQuiz/Resources/Assets.xcassets` (`aerial_*.imageset`) are true-color
crops generated from Sentinel-2 L2A data via the Copernicus Data Space Ecosystem's
Sentinel Hub Process API, centered on each country's capital city in a fixed ~30km-wide
box (tightened from an initial ~50km after product review — the wider crop felt too
zoomed-out to make out street-level detail on-screen). Per the Copernicus data terms,
this app displays the following attribution notice:

> Contains modified Copernicus Sentinel data (2025–2026)

Capital city coordinates for the original 58 countries come from `ne_10m_populated_places`
in [natural-earth-vector](https://github.com/nvkelso/natural-earth-vector) (Natural
Earth data, public domain, no attribution required). South Africa's crop is centered
on Cape Town instead, since its Aerial-mode question is about that city specifically
(see `Country.aerialCityName`), not the capital used elsewhere. Tanzania has the same
kind of override, centered on Dar es Salaam rather than the official capital, Dodoma.

`Country.populationMillions` (used in Aerial mode's pre-answer hint) comes from the
`POP_EST` field in `ne_10m_admin_0_countries`, same repo and license as above, for the
original 58 countries — figures are rounded to the nearest million and dated to that
dataset's `POP_YEAR` (2019 as of this writing), not live-updated.

### South America/Asia/Africa expansion (18 countries)

Venezuela, Ecuador, Uruguay, Bolivia, Iran, Malaysia, Singapore, Bangladesh, Sri Lanka,
United Arab Emirates, Mongolia, Algeria, Ethiopia, Ghana, Tanzania, Zimbabwe, Senegal,
and Democratic Republic of Congo were added the same way — flags from flag-icons,
contours from datasets/geo-countries, satellite crops from the same Sentinel Hub
pipeline. Two differences worth noting: capital-city coordinates for these 18 were
looked up directly rather than pulled from the `ne_10m_populated_places` file, and
`populationMillions` figures are general current estimates rather than sourced from
`ne_10m_admin_0_countries`'s `POP_EST` field — both are close enough for the app's
purposes (a hint and a fuzzy-match target, not a cited statistic) but aren't from the
exact same dataset/vintage as the original 58.
