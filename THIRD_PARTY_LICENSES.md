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
