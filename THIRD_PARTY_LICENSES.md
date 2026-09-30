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

Longitude is scaled by cos(the country's own mean latitude) at generation time — plotting
raw (longitude, latitude) ignores how much a degree of longitude shrinks toward the poles,
which made high-latitude countries render noticeably too wide (Canada/Russia by roughly
2.2x). The same regeneration pass also excludes landmasses far outside a country's own
latitude band (e.g. French Guiana, ~43° from mainland France) that passed the existing
area-ratio filter and made the parent country's shape nearly unrecognizable, while still
keeping legitimate outlying territory that's part of a country's known silhouette (Alaska,
Canada's Arctic islands, Svalbard).

## Country land-border data

`GeoQuiz/Resources/BorderData.swift` (used for Contours mode's Hint 1) is
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

### Cuba/Uganda/Ukraine expansion (3 countries)

Added the same way as the 18-country batch above — flags from flag-icons, contours from
datasets/geo-countries, satellite crops from the same Sentinel Hub pipeline (Havana,
Kampala, and Kyiv respectively; Kyiv's first-fetched scene was mostly obscured by cloud
cover, so a `leastCC`-mosaicked, cloud-free re-fetch was used instead). Capital-city
coordinates were looked up directly and `populationMillions` figures are general current
estimates, same caveats as above.

### 56-city expansion (multiple satellite cities per country)

Every country previously had exactly one Aerial-mode image (its capital, or the Cape
Town/Dar es Salaam overrides above). 56 additional, visually distinctive major cities
were added on top — purely additive, the original single entry per country is untouched
— giving 33 countries more than one possible satellite city (the US has the most, at 6
total). See `GeoQuiz/Resources/SatelliteCityData.swift` and `Country.allSatelliteCities`.
Sourced the same way as every other satellite crop: true-color Sentinel-2 L2A via the
Copernicus Data Space Ecosystem's Sentinel Hub Process API, `leastCC` mosaicking, a fixed
~30km-wide box centered on each city, coordinates looked up directly. Every one of these
56 uses the "a major city" Hint 1 descriptor, since none of them is a capital.

## Landmark images

The images in `GeoQuiz/Resources/Assets.xcassets` (`landmark_*.imageset`) are sourced
from [Wikimedia Commons](https://commons.wikimedia.org) (one file, 'File:Sheikh_Zayed_Mosque_view.jpg', is hosted locally on
en.wikipedia.org rather than mirrored to Commons, but carries the same CC BY-SA 4.0 license).
Each photo was resized down from a Commons-recommended thumbnail size (never the full-resolution
original, per Wikimedia's own request to scripted/bulk clients) into the app's standard
@1x/@2x/@3x imageset sizes. Every image carries a Creative Commons or public-domain license
permitting reuse; CC BY/CC BY-SA images are attributed in-app directly under each photo
(see `Landmark.attribution`) as well as in the table below.

Landmark selection deliberately avoids the single most obvious/famous option for countries with
many well-known landmarks (e.g. France's entries are Centre Pompidou, Jardin du Luxembourg, and
Sainte-Chapelle, not the Eiffel Tower) — see `GeoQuiz/Resources/LandmarkData.swift`. Twelve
countries with especially rich architectural/cultural history (France, Italy, Egypt, India,
Greece, China, Mexico, Peru, UK, Russia, Spain, Turkey) have 2-3 entries each from the original
set; every other country had exactly one until the historic/pop-culture batch below, which added
further entries unevenly (the US most heavily) the same way Satellite mode gives a few countries
multiple cities — see that section for the full picture of which countries now have more than one.

| Landmark | Country | File | License | Author |
|---|---|---|---|---|
| Golden Gate Bridge | US | Golden Gate Bridge as seen from Battery East.jpg | CC BY-SA 4.0 | Frank Schulenburg |
| CN Tower | CA | CN Tower logo.png | Public domain | Unknown author |
| Obelisco de Buenos Aires | AR | Buenos Aires (20234294752).jpg | CC BY 2.0 | Rodrigo Paredes from Ciudad Autónoma de Buenos Aires, Argentina |
| Teatro Amazonas | BR | Noite no Teatro Amazonas (cropped).jpg | CC BY-SA 4.0 | Susan Valentim |
| Moai (Easter Island) | CL | AhuTongariki.JPG | CC BY 2.5 | Ian Sewell |
| Cartagena Old Town | CO | Museo Naval del Caribe.JPG | CC BY-SA 3.0 | Sgonzalezb |
| Angel Falls | VE | SaltoAngel1.jpg | CC BY 2.0 | Rich Childs |
| La Compañía de Jesús | EC | Iglesia de La Compañía, Quito, Ecuador, 2015-07-22, DD 14... | CC BY-SA 4.0 | Diego Delso |
| Palacio Salvo | UY | Palacio Salvo Logo.jpg | CC0 | Coquimbo58 |
| Tiwanaku | BO | PUERTA DEL SOL TIWANAKU.jpg | CC BY-SA 4.0 | CLAUDIOLD |
| Cologne Cathedral | DE | Kölner Dom - Westfassade 2022 ohne Gerüst-0968 b.jpg | CC BY-SA 4.0 | Raimond Spekking |
| Schönbrunn Palace | AT | Wien - Schloss Schönbrunn.JPG | CC BY-SA 4.0 | C.Stadler/Bwag |
| Atomium | BE | The Atomium during civil twilight (DSCF1135).jpg | CC BY 4.0 | Trougnouf (Benoit Brummer) |
| Rila Monastery | BG | Rila Monastery, August 2013.jpg | CC BY-SA 3.0 | Raggatt2000 |
| Dubrovnik City Walls | HR | Dubrovnik s 24.jpg | CC BY-SA 4.0 | Miroslav.vajdic |
| Tombs of the Kings | CY | Tombs of the Kings (Paphos).jpg | CC BY-SA 3.0 | Mgiganteus1 at en.wikipedia |
| Charles Bridge | CZ | Praha Revolution 1848.jpg | Public domain | Unknown |
| Nyhavn | DK | The Nyhavn Canal 3.jpg | CC BY 4.0 | European Commission |
| Tallinn Old Town | EE | Old Town of Tallinn, Tallinn, Estonia - panoramio (58).jpg | CC BY-SA 3.0 | Ben Bender |
| Suomenlinna Fortress | FI | Suomenlinna aerial.JPG | Public domain | Migro |
| Hungarian Parliament Building | HU | Hungarian Parliament Building from across the Danube, 202... | CC BY 4.0 | Kilyann Le Hen |
| Cliffs of Moher | IE | Cliffs-Of-Moher-OBriens-From-South.JPG | CC BY-SA 3.0 | Bjørn Christian Tørrissen |
| House of the Blackheads | LV | House of Blackheads at Dusk 3, Riga, Latvia - Diliff.jpg | CC BY-SA 3.0 | Diliff |
| Trakai Island Castle | LT | Trakai castle 2016.jpg | CC BY-SA 4.0 | Skelanard (Aleksandr Petukhov) |
| Adolphe Bridge | LU | Adolphe Bridge post 2017 renovation works - 7 August 2018... | CC BY-SA 4.0 | Denise Hastert |
| Ġgantija Temples | MT | Ggantija Temple on Gozo.jpg | CC BY-SA 4.0 | FritzPhotography |
| Kinderdijk Windmills | NL | KinderdijkMolens02.jpg | CC BY-SA 3.0 | Lucas Hirschegger |
| Wawel Castle | PL | Wawel (4).jpg | CC BY-SA 4.0 | Monika Towiańska |
| Belém Tower | PT | Belém Tower in Lisbon, Portugal.jpg | CC BY-SA 4.0 | Lisbon Photoshoots |
| Bran Castle | RO | Castelul Bran2.jpg | CC BY-SA 3.0 ro | Dobre Cezar |
| Bratislava Castle | SK | Bratislava - Burg (b).JPG | CC BY-SA 4.0 | C.Stadler/Bwag |
| Lake Bled | SI | Lake Bled from the Mountain.jpg | CC BY-SA 3.0 | Canadianhockey91 |
| Vasa Museum | SE | Stockholm Vasa Museum and Nordic Museum 09.jpg | CC BY-SA 4.0 | Ad Meskens |
| Preikestolen (Pulpit Rock) | NO | Lyse Fjord et Preikestolen.jpg | CC BY-SA 4.0 | Clementp.fr |
| Chapel Bridge (Lucerne) | CH | Kapellbruecke.JPG | CC BY-SA 2.5 | Simon Koopmann |
| Borobudur | ID | Pradaksina.jpg | CC BY-SA 4.0 | Heri nugroho |
| Fushimi Inari Shrine | JP | Torii path with lantern at Fushimi Inari Taisha Shrine, K... | CC BY-SA 4.0 | Basile Morin |
| Hegra | SA | Qasr al Farid.JPG | CC BY-SA 4.0 | Richard.hargas |
| Gyeongbokgung Palace | KR | Front view of the Imperial Throne Hall Geunjeongjeon at G... | CC BY-SA 4.0 | Basile Morin |
| Wat Arun | TH | เจดีย์ประธานทรงปรางค์วัดอรุณ2.jpg | CC BY-SA 4.0 | Mastertongapollo |
| Ha Long Bay | VN | Ha Long Bay in 2019.jpg | CC BY-SA 4.0 | Taewangkorea |
| Banaue Rice Terraces | PH | Banaue-terrace.JPG | Public domain | User: (WT-shared) Roundtheworld at  wts wikivoyage |
| Badshahi Mosque | PK | Badshahi Mosque front picture.jpg | CC BY-SA 4.0 | Romero Maia |
| Masada | IL | Israel-2013-Aerial 21-Masada.jpg | CC BY-SA 4.0 | Godot13 |
| Persepolis | IR | Persepolis east side at spring.jpg | CC BY-SA 4.0 | Masoudkhalife |
| Batu Caves | MY | Batu Caves stairs 2022-05.jpg | CC BY-SA 4.0 | Chainwit. |
| Gardens by the Bay | SG | Supertree Grove, Gardens by the Bay, Singapore - 20120712... | CC BY 2.0 | Shiny Things. |
| Ahsan Manzil | BD | Ahsan Manzil-Front View.jpg | CC BY-SA 4.0 | Mahbub Hossain Shaheed (mahosha) |
| Sigiriya | LK | Sigiriya (141688197).jpeg | CC BY-SA 3.0 | Wrobell |
| Sheikh Zayed Grand Mosque | AE | Sheikh Zayed Mosque view.jpg (hosted locally on en.wikipe... | CC BY-SA 4.0 | Wikiemirati |
| Genghis Khan Equestrian Statue | MN | Genghis Khan Equestrian Statue, photo by Vaiz Ha.jpg | CC BY 2.0 | Vaiz Ha |
| Table Mountain | ZA | Table Mountain DanieVDM.jpg | CC BY 2.0 | Danie van der Merwe from Cape Town, South Africa |
| Zuma Rock | NG | Zuma Rock.jpg | CC BY 2.0 | Jeff Attaway |
| Fort Jesus | KE | Fort Jesus at the Mombasa Island.jpg | CC BY-SA 4.0 | Maingi030 |
| Hassan II Mosque | MA | Mosquee Hassan II - panoramio.jpg | CC BY-SA 3.0 | Jürgen Schneider |
| Casbah of Algiers | DZ | AlgerCasbah.jpg | CC BY-SA 2.0 | toufik Lerari |
| Churches of Lalibela | ET | Lalibela, san giorgio, esterno 24.jpg | CC BY 3.0 | Sailko |
| Larabanga Mosque | GH | Larabanga Mosque Ghana.jpg | CC BY-SA 3.0 | Sathyan Velumani |
| Stone Town | TZ | Zanzibar sultan palace.jpg | CC BY-SA 3.0 | No machine-readable author provided. Mbz1 assumed (based on copyright claims). |
| Great Zimbabwe | ZW | Conical Tower - Great Enclosure III (33736918448).jpg | CC BY-SA 2.0 | Andrew Moore from Johannesburg, South Africa |
| African Renaissance Monument | SN | Monument renaissance.jpg | CC BY-SA 4.0 | Tafsir207 |
| Nyiragongo Volcano | CD | An aerial view of the towering volcanic peak of Mt. Nyira... | CC BY-SA 2.0 | MONUSCO / Neil Wetmore |
| Uluru | AU | ULURU.jpg | CC BY-SA 4.0 | Ek2030372672 |
| Hobbiton Movie Set | NZ | Waterhouse Lake Front.jpg | CC BY-SA 4.0 | Harsh.gavhane |
| Centre Pompidou | FR | 0 Centre Georges-Pompidou - 1986 Paris.JPG | CC BY 4.0 | Jean-Pol GRANDMONT |
| Jardin du Luxembourg | FR | LuxembourgMontparnasse.JPG | Public domain | Kirua |
| Sainte-Chapelle | FR | Sainte Chapelle - Upper level 1.jpg | CC BY-SA 2.5 | Didier B (Sam67fr) |
| Duomo di Milano | IT | Milan Cathedral from Piazza del Duomo.jpg | CC BY-SA 3.0 | Jiuguang Wang |
| Ponte Vecchio | IT | Ponte Vecchio from Ponte alle Grazie.jpg | CC BY-SA 4.0 | Ingo Mehling |
| Trulli of Alberobello | IT | Alberobello - View from Piazza Giangirolamo II - 03.jpg | CC BY-SA 4.0 | Benjamin Smith |
| Abu Simbel | EG | Ramsis, Aswan Governorate, Egypt - panoramio.jpg | CC BY 3.0 | youssef_alam |
| Karnak Temple | EG | Temple de Louxor 68.jpg | CC BY-SA 4.0 | René Hourdry |
| Hawa Mahal | IN | East facade Hawa Mahal Jaipur from ground level (July 202... | CC BY-SA 4.0 | Chainwit. |
| Meenakshi Temple | IN | Mariage of Shiva and Parvati (Meenakshi) witnessed by Vis... | CC BY 2.0 | Richard Mortel from Riyadh, Saudi Arabia |
| Qutub Minar | IN | Qutb Minar 2022.jpg | CC BY 4.0 | Wasir kasab |
| Meteora | GR | Meteora's monastery 2.jpg | CC BY-SA 4.0 | Stathis floros |
| Palace of Knossos | GR | Neolithic pottery, AMH, 079001.jpg | CC BY-SA 4.0 | Zde |
| Windmills of Mykonos | GR | Against Greek skies, one of the Mykonos Island Windmills,... | CC BY-SA 3.0 | Mstyslav Chernov |
| Forbidden City | CN | The Forbidden City - View from Coal Hill.jpg | CC BY-SA 3.0 | Pixelflake |
| Terracotta Army | CN | 51714-Terracota-Army.jpg | CC BY 2.0 | xiquinhosilva |
| Zhangjiajie | CN | 1 tianzishan wulingyuan zhangjiajie 2012.jpg | CC BY-SA 4.0 | chensiyuan |
| Chichén Itzá | MX | Chichen Itza 3.jpg | CC BY-SA 4.0 | Daniel Schwen |
| Teotihuacán | MX | ZA77 Teotihuacán edo de mex Herberto de la rosa.jpg | CC BY-SA 4.0 | Hdlrosa |
| Machu Picchu | PE | Machu Picchu, 2023 (012).jpg | CC BY-SA 4.0 | Draceane |
| Nazca Lines | PE | Líneas de Nazca, Nazca, Perú, 2015-07-29, DD 49.JPG | CC BY-SA 4.0 | Diego Delso |
| Edinburgh Castle | GB | City of Edinburgh - Edinburgh Castle - 20140421004403.jpg | CC BY-SA 4.0 | Enric |
| Stonehenge | GB | Stonehenge2007 07 30.jpg | CC BY 2.0 | garethwiscombe |
| Peterhof Palace | RU | Peterhof Palace, Saint Petersburg, Russia (44408938295).jpg | CC BY 2.0 | Ninara from Helsinki, Finland |
| Hermitage Museum | RU | 1st Winter Palace.jpg | Public domain | Unknown author |
| Alhambra | ES | Dawn Charles V Palace Alhambra Granada Andalusia Spain.jpg | CC0 | Jebulon |
| Roman Aqueduct of Segovia | ES | Aqueduct of Segovia 08.jpg | CC BY-SA 3.0 | Bernard Gagnon |
| Cappadocia | TR | Cappadocia balloon trip, Ortahisar Castle (11893715185).jpg | CC BY 2.0 | Arian Zwegers from Brussels, Belgium |
| Pamukkale | TR | Pamukkale, Denizli 2026 68.jpg | CC BY-SA 4.0 | Biologg |


### Historic/pop-culture batch (26 entries)

A second Landmarks batch, unified into the same single pool as the architectural/cultural
set above (no visible grouping) — sourced the same way. Most entries still answer with the
country; a subset answer with a more specific city, US state (Texas, for The Alamo), or
place name (Pearl Harbor, Woodstock, Cape Canaveral) instead, based on how each place is
actually known — see `Landmark.answerType` in `GeoQuiz/Models/Landmark.swift`. Four proposed
entries (Tahrir Square, the former US Embassy in Tehran, Kuala Lumpur International Airport/
MH370, and Panmunjom/the Korean DMZ) were held back as touching live political situations
rather than settled history.

| Landmark | Country | File | License | Author |
|---|---|---|---|---|
| Wembley Stadium (Live Aid, 1985) | GB | Wembley Stadium Twin Towers.jpg | CC BY-SA 2.0 | Merv Payne |
| Apple Corps rooftop (1969) | GB | Saville Row from Burlington Gardens.jpg | CC BY-SA 2.0 | Dave Fergusson |
| Pont de l'Alma tunnel (1997) | FR | Pont de l'Alma, Paris 5 December 2016.jpg | CC BY 2.0 | Guilhem Vellut from Paris, France |
| Dealey Plaza (1963) | US | Dealey Plaza 2003.jpg | Public domain | Brodie319 |
| Brandenburg Gate (1989) | DE | Brandenburger Tor abends.jpg | CC BY-SA 3.0 | Thomas Wolf, www.foto-tw.de |
| Genbaku Dome (1945) | JP | Genbaku Dome04-r.JPG | CC BY 2.5 | Oilstreet |
| Maracanã Stadium (1950 World Cup) | BR | Maracana 2022.jpg | CC BY-SA 3.0 de | Arne Müseler |
| National September 11 Memorial | US | 9-11 Memorial and Museum (28815276064).jpg | CC BY 2.0 | Paul Sableman |
| Ed Sullivan Theater (1964) | US | Ed Sullivan Theater (48047407856).jpg | CC BY 2.0 | Ajay Suresh from New York, NY, USA |
| Watergate complex (1972) | US | Watergate complex, 2025.jpg | CC BY-SA 4.0 | PRRfan |
| EDSA (1986) | PH | EDSAShrine0135 07.JPG | CC BY-SA 3.0 | Ramon FVelasquez |
| Graceland | US | USA Tour 2019 P095 Graceland.jpg | CC BY-SA 4.0 | Fallaner |
| Sun Studio | US | Sun studio memphis.jpg | CC BY 2.0 | ant gorman |
| Chernobyl/Pripyat (1986) | UA | Aerial view of Pripyat.jpg | CC BY-SA 4.0 | Omar David Sandoval Sida |
| Runnymede (Magna Carta, 1215) | GB | RunnymedeMagnacartaisle.jpg | CC BY 3.0 | Wyrdlight |
| Fall of Saigon (1975) | VN | 20190923 Independence Palace-10.jpg | CC0 | Balon Greyjoy |
| Rumble in the Jungle (1974) | CD | Stade Tata Raphaël lors d'un de l'AS V.CLUB.jpg | CC BY-SA 4.0 | Yallahbye |
| Entebbe (1976 raid) | UG | Entebbe Airport.JPG | Public domain | User: (WT-shared) Katanasov at  wts wikivoyage |
| Bridge on the River Kwai | TH | Bridge on the River Kwai - tourist plaza.JPG | CC BY-SA 4.0 | PumpkinSky |
| Jallianwala Bagh (1919) | IN | Jallianwala Bagh, Amritsar 01.jpg | CC BY-SA 4.0 | Bernard Gagnon |
| Bay of Pigs (1961) | CU | Playagiron.jpg | CC BY-SA 3.0 | Bibit |
| Robben Island | ZA | Robben Island - Cape Town, South Africa (3883849594).jpg | CC BY 2.0 | South African Tourism from South Africa |
| The Alamo (1836) | US | Alamo pano.jpg | CC BY-SA 4.0 | Daniel Schwen |
| Pearl Harbor (1941) | US | USS Arizona Memorial (aerial view).jpg | Public domain | DoD photo by: PH3(AW/SW) JAYME PASTORIC, USN |
| Woodstock (1969) | US | Museum at Bethel Woods.jpg | CC BY-SA 4.0 | Seanbarnett |
| Cape Canaveral (Apollo missions) | US | VAB and SLS.jpg | Public domain | Kim Shiflett |
