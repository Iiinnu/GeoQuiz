import Foundation

/// The 93-entry Landmarks photo bank, sourced from Wikimedia Commons. Most countries
/// have exactly one entry; a handful with especially rich architectural/cultural
/// history (France, Italy, Egypt, India, Greece, China, Mexico, Peru, UK, Russia, Spain,
/// Turkey) have 2-3. Every image here carries a Commons license permitting reuse with
/// attribution (see `attribution`); see THIRD_PARTY_LICENSES.md for the full sourcing
/// notes.
enum LandmarkData {
    static func landmarks(forCountryID id: String) -> [Landmark] {
        all.filter { $0.countryID == id }
    }

    static let all: [Landmark] = [
        Landmark(
            id: "US_ggb", countryID: "US", name: "Golden Gate Bridge",
            eraFact: "This suspension bridge opened in 1937 and was the longest of its kind in the world for over two decades.",
            imageAssetRef: "landmark_US_ggb",
            attribution: "Golden Gate Bridge — Frank Schulenburg / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "CA_cntower", countryID: "CA", name: "CN Tower",
            eraFact: "This communications and observation tower was completed in 1976 and held the record for the world's tallest freestanding structure for over 30 years.",
            imageAssetRef: "landmark_CA_cntower",
            attribution: "CN Tower — Unknown author / Wikimedia Commons (Public domain)"
        ),
        Landmark(
            id: "AR_obelisco", countryID: "AR", name: "Obelisco de Buenos Aires",
            eraFact: "This obelisk was erected in 1936 to mark the 400th anniversary of the city's founding.",
            imageAssetRef: "landmark_AR_obelisco",
            attribution: "Obelisco de Buenos Aires — Rodrigo Paredes from Ciudad Autónoma de Buenos Aires, Argentina / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "BR_amazonas", countryID: "BR", name: "Teatro Amazonas",
            eraFact: "This opera house was built in the late 19th century during a rubber boom, with materials shipped in from Europe.",
            imageAssetRef: "landmark_BR_amazonas",
            attribution: "Teatro Amazonas — Susan Valentim / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "CL_moai", countryID: "CL", name: "Moai (Easter Island)",
            eraFact: "These monumental stone figures were carved by an indigenous Polynesian people between roughly the 13th and 16th centuries.",
            imageAssetRef: "landmark_CL_moai",
            attribution: "Moai (Easter Island) — Ian Sewell / Wikimedia Commons (CC BY 2.5)"
        ),
        Landmark(
            id: "CO_cartagena", countryID: "CO", name: "Cartagena Old Town",
            eraFact: "This walled colonial port city was fortified by the Spanish starting in the 16th century to defend against pirate raids.",
            imageAssetRef: "landmark_CO_cartagena",
            attribution: "Cartagena Old Town — Sgonzalezb / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "VE_angel", countryID: "VE", name: "Angel Falls",
            eraFact: "This is the world's tallest uninterrupted waterfall, named after an American aviator who flew over it in the 1930s.",
            imageAssetRef: "landmark_VE_angel",
            attribution: "Angel Falls — Rich Childs / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "EC_compania", countryID: "EC", name: "La Compañía de Jesús",
            eraFact: "This Jesuit church took over a century and a half to build, starting in the early 17th century, and its interior is almost entirely covered in gold leaf.",
            imageAssetRef: "landmark_EC_compania",
            attribution: "La Compañía de Jesús — Diego Delso / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "UY_salvo", countryID: "UY", name: "Palacio Salvo",
            eraFact: "This early 20th-century skyscraper was, for a time, the tallest building in South America.",
            imageAssetRef: "landmark_UY_salvo",
            attribution: "Palacio Salvo — Coquimbo58 / Wikimedia Commons (CC0)"
        ),
        Landmark(
            id: "BO_tiwanaku", countryID: "BO", name: "Tiwanaku",
            eraFact: "These monumental stone ruins were built by a civilization that predates a well-known later empire in the same region by centuries.",
            imageAssetRef: "landmark_BO_tiwanaku",
            attribution: "Tiwanaku — CLAUDIOLD / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "DE_cologne", countryID: "DE", name: "Cologne Cathedral",
            eraFact: "Construction on this Gothic cathedral began in the 13th century but wasn't completed until the late 19th century.",
            imageAssetRef: "landmark_DE_cologne",
            attribution: "Cologne Cathedral — Raimond Spekking / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "AT_schonbrunn", countryID: "AT", name: "Schönbrunn Palace",
            eraFact: "This former imperial summer residence has over 1,400 rooms and was built in the 17th-18th centuries.",
            imageAssetRef: "landmark_AT_schonbrunn",
            attribution: "Schönbrunn Palace — C.Stadler/Bwag / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "BE_atomium", countryID: "BE", name: "Atomium",
            eraFact: "This structure, modeled on an iron crystal magnified billions of times, was built for a World's Fair in 1958.",
            imageAssetRef: "landmark_BE_atomium",
            attribution: "Atomium — Trougnouf (Benoit Brummer) / Wikimedia Commons (CC BY 4.0)"
        ),
        Landmark(
            id: "BG_rila", countryID: "BG", name: "Rila Monastery",
            eraFact: "This Eastern Orthodox monastery was founded in the 10th century and is considered a symbol of the local national identity.",
            imageAssetRef: "landmark_BG_rila",
            attribution: "Rila Monastery — Raggatt2000 / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "HR_dubrovnik", countryID: "HR", name: "Dubrovnik City Walls",
            eraFact: "These fortifications, nearly 2 kilometers long, were built and reinforced between the 13th and 16th centuries to protect a maritime trading republic.",
            imageAssetRef: "landmark_HR_dubrovnik",
            attribution: "Dubrovnik City Walls — Miroslav.vajdic / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "CY_tombs", countryID: "CY", name: "Tombs of the Kings",
            eraFact: "This large underground necropolis was carved from solid rock starting in the 4th century BC, for the elite of an ancient city rather than actual royalty.",
            imageAssetRef: "landmark_CY_tombs",
            attribution: "Tombs of the Kings — Mgiganteus1 at en.wikipedia / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "CZ_charles", countryID: "CZ", name: "Charles Bridge",
            eraFact: "Construction on this stone bridge began in 1357 and it was, for centuries, the only way to cross the river it spans in this city.",
            imageAssetRef: "landmark_CZ_charles",
            attribution: "Charles Bridge — Unknown / Wikimedia Commons (Public domain)"
        ),
        Landmark(
            id: "DK_nyhavn", countryID: "DK", name: "Nyhavn",
            eraFact: "This colorful 17th-century waterfront canal was once a busy commercial port lined with taverns for sailors.",
            imageAssetRef: "landmark_DK_nyhavn",
            attribution: "Nyhavn — European Commission / Wikimedia Commons (CC BY 4.0)"
        ),
        Landmark(
            id: "EE_tallinn", countryID: "EE", name: "Tallinn Old Town",
            eraFact: "This medieval walled town center has been continuously inhabited since at least the 13th century and is one of the best-preserved of its kind in Europe.",
            imageAssetRef: "landmark_EE_tallinn",
            attribution: "Tallinn Old Town — Ben Bender / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "FI_suomenlinna", countryID: "FI", name: "Suomenlinna Fortress",
            eraFact: "This sea fortress was built across several islands starting in the mid-18th century to defend a strategic harbor.",
            imageAssetRef: "landmark_FI_suomenlinna",
            attribution: "Suomenlinna Fortress — Migro / Wikimedia Commons (Public domain)"
        ),
        Landmark(
            id: "HU_parliament", countryID: "HU", name: "Hungarian Parliament Building",
            eraFact: "Completed in 1904, this was for a time the largest parliament building in the world.",
            imageAssetRef: "landmark_HU_parliament",
            attribution: "Hungarian Parliament Building — Kilyann Le Hen / Wikimedia Commons (CC BY 4.0)"
        ),
        Landmark(
            id: "IE_moher", countryID: "IE", name: "Cliffs of Moher",
            eraFact: "These sea cliffs rise as high as 214 meters and were shaped over millions of years by the Atlantic Ocean.",
            imageAssetRef: "landmark_IE_moher",
            attribution: "Cliffs of Moher — Bjørn Christian Tørrissen / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "LV_blackheads", countryID: "LV", name: "House of the Blackheads",
            eraFact: "This guild hall was originally built in the 14th century for a society of unmarried merchants and was completely reconstructed after being destroyed in World War II.",
            imageAssetRef: "landmark_LV_blackheads",
            attribution: "House of the Blackheads — Diliff / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "LT_trakai", countryID: "LT", name: "Trakai Island Castle",
            eraFact: "This Gothic castle was built on an island in the 14th-15th centuries as a residence for a Grand Duke.",
            imageAssetRef: "landmark_LT_trakai",
            attribution: "Trakai Island Castle — Skelanard (Aleksandr Petukhov) / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "LU_adolphe", countryID: "LU", name: "Adolphe Bridge",
            eraFact: "When it opened in 1903, this stone arch bridge had the largest arch span of its kind in the world.",
            imageAssetRef: "landmark_LU_adolphe",
            attribution: "Adolphe Bridge — Denise Hastert / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "MT_ggantija", countryID: "MT", name: "Ġgantija Temples",
            eraFact: "These megalithic temples were built around 3600 BC, making them older than both the pyramids of Egypt and Stonehenge.",
            imageAssetRef: "landmark_MT_ggantija",
            attribution: "Ġgantija Temples — FritzPhotography / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "NL_kinderdijk", countryID: "NL", name: "Kinderdijk Windmills",
            eraFact: "This group of 19 windmills was built around 1740 to help drain a low-lying area that sits below sea level.",
            imageAssetRef: "landmark_NL_kinderdijk",
            attribution: "Kinderdijk Windmills — Lucas Hirschegger / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "PL_wawel", countryID: "PL", name: "Wawel Castle",
            eraFact: "This royal castle complex was, for centuries, the seat of monarchs before the capital moved elsewhere.",
            imageAssetRef: "landmark_PL_wawel",
            attribution: "Wawel Castle — Monika Towiańska / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "PT_belem", countryID: "PT", name: "Belém Tower",
            eraFact: "This fortified tower was built in the early 16th century to defend a river harbor, and ships once departed from nearby on major voyages of exploration.",
            imageAssetRef: "landmark_PT_belem",
            attribution: "Belém Tower — Lisbon Photoshoots / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "RO_bran", countryID: "RO", name: "Bran Castle",
            eraFact: "This 14th-century fortress is popularly associated with a famous vampire novel, though the author never actually visited it.",
            imageAssetRef: "landmark_RO_bran",
            attribution: "Bran Castle — Dobre Cezar / Wikimedia Commons (CC BY-SA 3.0 ro)"
        ),
        Landmark(
            id: "SK_bratislava", countryID: "SK", name: "Bratislava Castle",
            eraFact: "This hilltop castle's origins date back centuries, and its current form was rebuilt in the 20th century after decades as a ruin.",
            imageAssetRef: "landmark_SK_bratislava",
            attribution: "Bratislava Castle — C.Stadler/Bwag / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "SI_bled", countryID: "SI", name: "Lake Bled",
            eraFact: "This alpine lake features a small island with a church, reachable only by traditional wooden boats or by swimming.",
            imageAssetRef: "landmark_SI_bled",
            attribution: "Lake Bled — Canadianhockey91 / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "SE_vasa", countryID: "SE", name: "Vasa Museum",
            eraFact: "This museum houses a 17th-century warship that sank on its maiden voyage and was recovered largely intact after over 300 years underwater.",
            imageAssetRef: "landmark_SE_vasa",
            attribution: "Vasa Museum — Ad Meskens / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "NO_preikestolen", countryID: "NO", name: "Preikestolen (Pulpit Rock)",
            eraFact: "This flat-topped cliff rises 604 meters above a fjord and was formed by ice wedging during the last ice age.",
            imageAssetRef: "landmark_NO_preikestolen",
            attribution: "Preikestolen (Pulpit Rock) — Clementp.fr / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "CH_chapel", countryID: "CH", name: "Chapel Bridge (Lucerne)",
            eraFact: "Built in the 14th century, this covered wooden bridge is one of the oldest of its kind still standing in Europe, despite a fire that destroyed much of it in 1993.",
            imageAssetRef: "landmark_CH_chapel",
            attribution: "Chapel Bridge (Lucerne) — Simon Koopmann / Wikimedia Commons (CC BY-SA 2.5)"
        ),
        Landmark(
            id: "ID_borobudur", countryID: "ID", name: "Borobudur",
            eraFact: "This is the world's largest Buddhist temple, built in the 8th and 9th centuries and later abandoned and hidden under volcanic ash for centuries.",
            imageAssetRef: "landmark_ID_borobudur",
            attribution: "Borobudur — Heri nugroho / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "JP_fushimi", countryID: "JP", name: "Fushimi Inari Shrine",
            eraFact: "This shrine is famous for thousands of vermilion gates donated by individuals and businesses over centuries, forming tunnel-like paths up a mountain.",
            imageAssetRef: "landmark_JP_fushimi",
            attribution: "Fushimi Inari Shrine — Basile Morin / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "SA_hegra", countryID: "SA", name: "Hegra",
            eraFact: "This site contains monumental tombs carved into rock by an ancient trading civilization over 2,000 years ago, and was this country's first UNESCO World Heritage Site.",
            imageAssetRef: "landmark_SA_hegra",
            attribution: "Hegra — Richard.hargas / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "KR_gyeongbok", countryID: "KR", name: "Gyeongbokgung Palace",
            eraFact: "This was the main royal palace of a dynasty that ruled for over 500 years, first built in the late 14th century.",
            imageAssetRef: "landmark_KR_gyeongbok",
            attribution: "Gyeongbokgung Palace — Basile Morin / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "TH_watarun", countryID: "TH", name: "Wat Arun",
            eraFact: "This Buddhist temple takes its name from a god of dawn and is decorated with colorful porcelain in a style dating to the early 19th century.",
            imageAssetRef: "landmark_TH_watarun",
            attribution: "Wat Arun — Mastertongapollo / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "VN_halong", countryID: "VN", name: "Ha Long Bay",
            eraFact: "This bay contains thousands of limestone karsts and islands formed over roughly 500 million years.",
            imageAssetRef: "landmark_VN_halong",
            attribution: "Ha Long Bay — Taewangkorea / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "PH_banaue", countryID: "PH", name: "Banaue Rice Terraces",
            eraFact: "These terraces were carved into mountainsides roughly 2,000 years ago, entirely by hand, without modern tools.",
            imageAssetRef: "landmark_PH_banaue",
            attribution: "Banaue Rice Terraces — Wikivoyage user Roundtheworld / Wikimedia Commons (Public domain)"
        ),
        Landmark(
            id: "PK_badshahi", countryID: "PK", name: "Badshahi Mosque",
            eraFact: "Completed in 1673, this was for nearly 300 years the largest mosque in the world.",
            imageAssetRef: "landmark_PK_badshahi",
            attribution: "Badshahi Mosque — Romero Maia / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "IL_masada", countryID: "IL", name: "Masada",
            eraFact: "This isolated plateau fortress was built in the 1st century BC and became the site of a mass siege by an occupying empire decades later.",
            imageAssetRef: "landmark_IL_masada",
            attribution: "Masada — Godot13 / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "IR_persepolis", countryID: "IR", name: "Persepolis",
            eraFact: "This was the ceremonial capital of an ancient empire, founded around 518 BC and burned during a famous military campaign roughly two centuries later.",
            imageAssetRef: "landmark_IR_persepolis",
            attribution: "Persepolis — Masoudkhalife / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "MY_batu", countryID: "MY", name: "Batu Caves",
            eraFact: "These limestone caves have served as a place of worship for over a century and are reached by climbing hundreds of steps.",
            imageAssetRef: "landmark_MY_batu",
            attribution: "Batu Caves — Chainwit. / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "SG_gardens", countryID: "SG", name: "Gardens by the Bay",
            eraFact: "This nature park, opened in 2012, features towering artificial 'supertrees' that generate solar power and support vertical gardens.",
            imageAssetRef: "landmark_SG_gardens",
            attribution: "Gardens by the Bay — Shiny Things. / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "BD_ahsan", countryID: "BD", name: "Ahsan Manzil",
            eraFact: "This pink palace was the seat of a wealthy landowning family in the 19th century and now serves as a national museum.",
            imageAssetRef: "landmark_BD_ahsan",
            attribution: "Ahsan Manzil — Mahbub Hossain Shaheed (mahosha) / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "LK_sigiriya", countryID: "LK", name: "Sigiriya",
            eraFact: "This ancient rock fortress was built atop a 200-meter-high column of rock in the 5th century, complete with elaborate frescoes and gardens.",
            imageAssetRef: "landmark_LK_sigiriya",
            attribution: "Sigiriya — Wrobell / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "AE_szmosque", countryID: "AE", name: "Sheikh Zayed Grand Mosque",
            eraFact: "Completed in 2007, this mosque can hold over 40,000 worshippers and features one of the world's largest hand-knotted carpets.",
            imageAssetRef: "landmark_AE_szmosque",
            attribution: "Sheikh Zayed Grand Mosque — Wikiemirati / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "MN_genghis", countryID: "MN", name: "Genghis Khan Equestrian Statue",
            eraFact: "At 40 meters tall, this stainless steel statue is one of the largest equestrian statues in the world, completed in 2008.",
            imageAssetRef: "landmark_MN_genghis",
            attribution: "Genghis Khan Equestrian Statue — Vaiz Ha / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "ZA_table", countryID: "ZA", name: "Table Mountain",
            eraFact: "This flat-topped mountain is estimated to be around 260 million years old, far older than many of the world's other famous mountain ranges.",
            imageAssetRef: "landmark_ZA_table",
            attribution: "Table Mountain — Danie van der Merwe from Cape Town, South Africa / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "NG_zuma", countryID: "NG", name: "Zuma Rock",
            eraFact: "This 725-meter monolith rises abruptly from flat surrounding plains and is sometimes called a natural gateway to the capital region.",
            imageAssetRef: "landmark_NG_zuma",
            attribution: "Zuma Rock — Jeff Attaway / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "KE_fortjesus", countryID: "KE", name: "Fort Jesus",
            eraFact: "This coastal fort was built in the late 16th century by a colonial naval power to control trade along the coast.",
            imageAssetRef: "landmark_KE_fortjesus",
            attribution: "Fort Jesus — Maingi030 / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "MA_hassan2", countryID: "MA", name: "Hassan II Mosque",
            eraFact: "Completed in 1993, this mosque has one of the tallest minarets in the world and sits partly over the ocean.",
            imageAssetRef: "landmark_MA_hassan2",
            attribution: "Hassan II Mosque — Jürgen Schneider / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "DZ_casbah", countryID: "DZ", name: "Casbah of Algiers",
            eraFact: "This densely packed citadel and old town dates back over a thousand years and sits above a harbor once used as a base by privateers.",
            imageAssetRef: "landmark_DZ_casbah",
            attribution: "Casbah of Algiers — toufik Lerari / Wikimedia Commons (CC BY-SA 2.0)"
        ),
        Landmark(
            id: "ET_lalibela", countryID: "ET", name: "Churches of Lalibela",
            eraFact: "These 11 churches were carved directly out of solid volcanic rock in the 12th and 13th centuries, entirely below ground level.",
            imageAssetRef: "landmark_ET_lalibela",
            attribution: "Churches of Lalibela — Sailko / Wikimedia Commons (CC BY 3.0)"
        ),
        Landmark(
            id: "GH_larabanga", countryID: "GH", name: "Larabanga Mosque",
            eraFact: "Built in a distinctive mud-and-timber style, this is one of the oldest mosques in the region, with origins said to date to the early 15th century.",
            imageAssetRef: "landmark_GH_larabanga",
            attribution: "Larabanga Mosque — Sathyan Velumani / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "TZ_stonetown", countryID: "TZ", name: "Stone Town",
            eraFact: "This old trading town flourished in the 19th century as a hub of the spice trade along the coast.",
            imageAssetRef: "landmark_TZ_stonetown",
            attribution: "Stone Town — No machine-readable author provided. Mbz1 assumed (based on copyright claims). / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "ZW_greatzim", countryID: "ZW", name: "Great Zimbabwe",
            eraFact: "These stone ruins were the capital of a thriving kingdom between roughly the 11th and 15th centuries, built entirely without mortar.",
            imageAssetRef: "landmark_ZW_greatzim",
            attribution: "Great Zimbabwe — Andrew Moore from Johannesburg, South Africa / Wikimedia Commons (CC BY-SA 2.0)"
        ),
        Landmark(
            id: "SN_renaissance", countryID: "SN", name: "African Renaissance Monument",
            eraFact: "Completed in 2010, this bronze statue is taller than the Statue of Liberty and was built to mark 50 years of independence.",
            imageAssetRef: "landmark_SN_renaissance",
            attribution: "African Renaissance Monument — Tafsir207 / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "CD_nyiragongo", countryID: "CD", name: "Nyiragongo Volcano",
            eraFact: "This active volcano contains one of the largest lava lakes in the world within its crater.",
            imageAssetRef: "landmark_CD_nyiragongo",
            attribution: "Nyiragongo Volcano — MONUSCO / Neil Wetmore / Wikimedia Commons (CC BY-SA 2.0)"
        ),
        Landmark(
            id: "AU_uluru", countryID: "AU", name: "Uluru",
            eraFact: "This massive sandstone monolith is sacred to the indigenous people of the region and is believed to have formed around 550 million years ago.",
            imageAssetRef: "landmark_AU_uluru",
            attribution: "Uluru — Ek2030372672 / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "NZ_hobbiton", countryID: "NZ", name: "Hobbiton Movie Set",
            eraFact: "Originally built as a temporary film set in the late 1990s, this site was rebuilt with permanent materials and left standing as a tourist attraction.",
            imageAssetRef: "landmark_NZ_hobbiton",
            attribution: "Hobbiton Movie Set — Harsh.gavhane / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "FR_pompidou", countryID: "FR", name: "Centre Pompidou",
            eraFact: "Opened in 1977, this museum is known for its inside-out architecture, with structural and mechanical systems exposed on the building's exterior.",
            imageAssetRef: "landmark_FR_pompidou",
            attribution: "Centre Pompidou — Jean-Pol GRANDMONT / Wikimedia Commons (CC BY 4.0)"
        ),
        Landmark(
            id: "FR_luxembourg", countryID: "FR", name: "Jardin du Luxembourg",
            eraFact: "These formal gardens were laid out in the early 17th century around a palace built for a queen.",
            imageAssetRef: "landmark_FR_luxembourg",
            attribution: "Jardin du Luxembourg — Kirua / Wikimedia Commons (Public domain)"
        ),
        Landmark(
            id: "FR_saintechapelle", countryID: "FR", name: "Sainte-Chapelle",
            eraFact: "This royal chapel was completed in 1248 to house relics and is famous for stained glass windows that make up most of its upper walls.",
            imageAssetRef: "landmark_FR_saintechapelle",
            attribution: "Sainte-Chapelle — Didier B (Sam67fr) / Wikimedia Commons (CC BY-SA 2.5)"
        ),
        Landmark(
            id: "IT_duomomilano", countryID: "IT", name: "Duomo di Milano",
            eraFact: "Construction on this Gothic cathedral began in 1386 and took nearly six centuries to fully complete.",
            imageAssetRef: "landmark_IT_duomomilano",
            attribution: "Duomo di Milano — Jiuguang Wang / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "IT_pontevecchio", countryID: "IT", name: "Ponte Vecchio",
            eraFact: "This medieval stone bridge is lined with shops and was the only bridge in its city to survive a retreating army's demolitions during World War II.",
            imageAssetRef: "landmark_IT_pontevecchio",
            attribution: "Ponte Vecchio — Ingo Mehling / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "IT_alberobello", countryID: "IT", name: "Trulli of Alberobello",
            eraFact: "This town is known for a distinctive style of drystone huts with conical roofs, a construction method used since at least the 14th century.",
            imageAssetRef: "landmark_IT_alberobello",
            attribution: "Trulli of Alberobello — Benjamin Smith / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "EG_abusimbel", countryID: "EG", name: "Abu Simbel",
            eraFact: "These massive rock temples were carved in the 13th century BC and, in the 1960s, were cut apart and relocated to save them from a rising reservoir.",
            imageAssetRef: "landmark_EG_abusimbel",
            attribution: "Abu Simbel — youssef_alam / Wikimedia Commons (CC BY 3.0)"
        ),
        Landmark(
            id: "EG_karnak", countryID: "EG", name: "Karnak Temple",
            eraFact: "This vast temple complex was built and expanded over roughly 2,000 years by generations of ancient rulers.",
            imageAssetRef: "landmark_EG_karnak",
            attribution: "Karnak Temple — René Hourdry / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "IN_hawamahal", countryID: "IN", name: "Hawa Mahal",
            eraFact: "Built in 1799, this five-story palace has hundreds of small windows originally designed to let royal women observe street life unseen.",
            imageAssetRef: "landmark_IN_hawamahal",
            attribution: "Hawa Mahal — Chainwit. / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "IN_meenakshi", countryID: "IN", name: "Meenakshi Temple",
            eraFact: "This temple complex features towering gateway towers covered in thousands of colorful sculpted figures, largely built in the 16th and 17th centuries.",
            imageAssetRef: "landmark_IN_meenakshi",
            attribution: "Meenakshi Temple — Richard Mortel from Riyadh, Saudi Arabia / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "IN_qutubminar", countryID: "IN", name: "Qutub Minar",
            eraFact: "At 73 meters, this is the tallest brick minaret in the world, construction begun in 1193.",
            imageAssetRef: "landmark_IN_qutubminar",
            attribution: "Qutub Minar — Wasir kasab / Wikimedia Commons (CC BY 4.0)"
        ),
        Landmark(
            id: "GR_meteora", countryID: "GR", name: "Meteora",
            eraFact: "These monasteries were built atop natural sandstone pillars starting in the 14th century, chosen for their near-inaccessibility.",
            imageAssetRef: "landmark_GR_meteora",
            attribution: "Meteora — Stathis floros / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "GR_knossos", countryID: "GR", name: "Palace of Knossos",
            eraFact: "This Bronze Age palace complex, first built around 1900 BC, is associated with a famous myth involving a labyrinth.",
            imageAssetRef: "landmark_GR_knossos",
            attribution: "Palace of Knossos — Zde / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "GR_mykonos", countryID: "GR", name: "Windmills of Mykonos",
            eraFact: "These whitewashed windmills date mostly from the 16th century and were once used to mill wheat, harnessing the region's strong winds.",
            imageAssetRef: "landmark_GR_mykonos",
            attribution: "Windmills of Mykonos — Mstyslav Chernov / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "CN_forbiddencity", countryID: "CN", name: "Forbidden City",
            eraFact: "This palace complex served as the imperial home for 24 emperors across two dynasties, from 1420 until the early 20th century.",
            imageAssetRef: "landmark_CN_forbiddencity",
            attribution: "Forbidden City — Pixelflake / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "CN_terracotta", countryID: "CN", name: "Terracotta Army",
            eraFact: "These thousands of life-sized clay soldiers were buried around 210 BC to accompany a first unifying emperor into the afterlife.",
            imageAssetRef: "landmark_CN_terracotta",
            attribution: "Terracotta Army — xiquinhosilva / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "CN_zhangjiajie", countryID: "CN", name: "Zhangjiajie",
            eraFact: "This national park's thousands of narrow sandstone pillars, some over 200 meters tall, are said to have inspired floating mountains in a famous film.",
            imageAssetRef: "landmark_CN_zhangjiajie",
            attribution: "Zhangjiajie — chensiyuan / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "MX_chichenitza", countryID: "MX", name: "Chichén Itzá",
            eraFact: "This complex was a major city of a Mesoamerican civilization, with its central pyramid built to align precisely with the sun on the equinoxes.",
            imageAssetRef: "landmark_MX_chichenitza",
            attribution: "Chichén Itzá — Daniel Schwen / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "MX_teotihuacan", countryID: "MX", name: "Teotihuacán",
            eraFact: "At its peak around 500 AD, this ancient city may have had over 100,000 residents, though the identity of its original builders remains uncertain.",
            imageAssetRef: "landmark_MX_teotihuacan",
            attribution: "Teotihuacán — Hdlrosa / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "PE_machupicchu", countryID: "PE", name: "Machu Picchu",
            eraFact: "This mountaintop citadel was built in the 15th century as an estate for an emperor and was never found by colonial conquerors.",
            imageAssetRef: "landmark_PE_machupicchu",
            attribution: "Machu Picchu — Draceane / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "PE_nazca", countryID: "PE", name: "Nazca Lines",
            eraFact: "These enormous geoglyphs, some depicting animals over 100 meters across, were etched into the desert floor roughly 2,000 years ago and are best seen from the air.",
            imageAssetRef: "landmark_PE_nazca",
            attribution: "Nazca Lines — Diego Delso / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "GB_edinburgh", countryID: "GB", name: "Edinburgh Castle",
            eraFact: "This fortress sits atop an extinct volcanic plug and has been besieged more times than almost any other place in the region's history.",
            imageAssetRef: "landmark_GB_edinburgh",
            attribution: "Edinburgh Castle — Enric / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "GB_stonehenge", countryID: "GB", name: "Stonehenge",
            eraFact: "This ring of massive standing stones was erected in stages starting around 3000 BC, and some stones were transported from over 150 miles away.",
            imageAssetRef: "landmark_GB_stonehenge",
            attribution: "Stonehenge — garethwiscombe / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "RU_peterhof", countryID: "RU", name: "Peterhof Palace",
            eraFact: "This palace and garden complex was commissioned in the early 18th century by a tsar who wanted to rival a famous French royal residence.",
            imageAssetRef: "landmark_RU_peterhof",
            attribution: "Peterhof Palace — Ninara from Helsinki, Finland / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "RU_hermitage", countryID: "RU", name: "Hermitage Museum",
            eraFact: "Originally the winter residence of the royal family, this palace now houses one of the largest art museums in the world.",
            imageAssetRef: "landmark_RU_hermitage",
            attribution: "Hermitage Museum — Unknown author / Wikimedia Commons (Public domain)"
        ),
        Landmark(
            id: "ES_alhambra", countryID: "ES", name: "Alhambra",
            eraFact: "This palace and fortress complex was built mainly in the 13th and 14th centuries by a Muslim dynasty during the final centuries of Islamic rule in the region.",
            imageAssetRef: "landmark_ES_alhambra",
            attribution: "Alhambra — Jebulon / Wikimedia Commons (CC0)"
        ),
        Landmark(
            id: "ES_segovia", countryID: "ES", name: "Roman Aqueduct of Segovia",
            eraFact: "Built around the 1st century AD, this aqueduct carried water for over 15 kilometers and remained in use until the late 19th century.",
            imageAssetRef: "landmark_ES_segovia",
            attribution: "Roman Aqueduct of Segovia — Bernard Gagnon / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "TR_cappadocia", countryID: "TR", name: "Cappadocia",
            eraFact: "This region's soft volcanic rock was carved into homes, churches, and entire underground cities starting thousands of years ago.",
            imageAssetRef: "landmark_TR_cappadocia",
            attribution: "Cappadocia — Arian Zwegers from Brussels, Belgium / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "TR_pamukkale", countryID: "TR", name: "Pamukkale",
            eraFact: "This site's white terraces were formed over thousands of years by mineral-rich hot springs cascading down a hillside.",
            imageAssetRef: "landmark_TR_pamukkale",
            attribution: "Pamukkale — Biologg / Wikimedia Commons (CC BY-SA 4.0)"
        ),

        Landmark(
            id: "GB_wembley", countryID: "GB", name: "Wembley Stadium (Live Aid, 1985)",
            eraFact: "Europe. In 1985 this stadium hosted one half of a simultaneous two-continent benefit concert for African famine relief.",
            imageAssetRef: "landmark_GB_wembley",
            attribution: "Wembley Stadium (Live Aid, 1985) — Merv Payne / Wikimedia Commons (CC BY-SA 2.0)",
            answerType: .city, answerText: "London",
            answerAliases: []
        ),
        Landmark(
            id: "GB_savilerow", countryID: "GB", name: "Apple Corps rooftop (1969)",
            eraFact: "Europe. In 1969 a hugely famous band gave an unannounced rooftop performance above a fashionable shopping street, cut short by the police.",
            imageAssetRef: "landmark_GB_savilerow",
            attribution: "Apple Corps rooftop (1969) — Dave Fergusson / Wikimedia Commons (CC BY-SA 2.0)",
            answerType: .city, answerText: "London",
            answerAliases: []
        ),
        Landmark(
            id: "FR_pontalma", countryID: "FR", name: "Pont de l'Alma tunnel (1997)",
            eraFact: "Europe. This road tunnel beneath a bridge became the site of a car crash in 1997 that dominated headlines worldwide.",
            imageAssetRef: "landmark_FR_pontalma",
            attribution: "Pont de l'Alma tunnel (1997) — Guilhem Vellut from Paris, France / Wikimedia Commons (CC BY 2.0)",
            answerType: .city, answerText: "Paris",
            answerAliases: []
        ),
        Landmark(
            id: "US_dealey", countryID: "US", name: "Dealey Plaza (1963)",
            eraFact: "North America. This public plaza was the site of a presidential motorcade shooting in 1963 that shocked the world.",
            imageAssetRef: "landmark_US_dealey",
            attribution: "Dealey Plaza (1963) — Brodie319 / Wikimedia Commons (Public domain)",
            answerType: .city, answerText: "Dallas",
            answerAliases: []
        ),
        Landmark(
            id: "DE_brandenburg", countryID: "DE", name: "Brandenburg Gate (1989)",
            eraFact: "Europe. Crowds gathered at this 18th-century gate in 1989 as a decades-long divide through the middle of a city finally came down.",
            imageAssetRef: "landmark_DE_brandenburg",
            attribution: "Brandenburg Gate (1989) — Thomas Wolf, www.foto-tw.de / Wikimedia Commons (CC BY-SA 3.0)",
            answerType: .city, answerText: "Berlin",
            answerAliases: []
        ),
        Landmark(
            id: "JP_genbaku", countryID: "JP", name: "Genbaku Dome (1945)",
            eraFact: "Asia. One of the only structures left standing near ground zero of the first wartime use of a nuclear weapon, in 1945, deliberately preserved as a ruin.",
            imageAssetRef: "landmark_JP_genbaku",
            attribution: "Genbaku Dome (1945) — Oilstreet / Wikimedia Commons (CC BY 2.5)",
            answerType: .city, answerText: "Hiroshima",
            answerAliases: []
        ),
        Landmark(
            id: "BR_maracana", countryID: "BR", name: "Maracanã Stadium (1950 World Cup)",
            eraFact: "South America. This stadium hosted the deciding match of the 1950 World Cup in front of what's still one of the largest football crowds ever recorded.",
            imageAssetRef: "landmark_BR_maracana",
            attribution: "Maracanã Stadium (1950 World Cup) — Arne Müseler / Wikimedia Commons (CC BY-SA 3.0 de)",
            answerType: .city, answerText: "Rio de Janeiro",
            answerAliases: ["Rio"]
        ),
        Landmark(
            id: "US_911memorial", countryID: "US", name: "National September 11 Memorial",
            eraFact: "North America. Twin reflecting pools mark the footprints of two towers lost in a 2001 attack, each ringed with the names of those killed.",
            imageAssetRef: "landmark_US_911memorial",
            attribution: "National September 11 Memorial — Paul Sableman / Wikimedia Commons (CC BY 2.0)",
            answerType: .city, answerText: "New York",
            answerAliases: ["New York City", "NYC"]
        ),
        Landmark(
            id: "US_edsullivan", countryID: "US", name: "Ed Sullivan Theater (1964)",
            eraFact: "North America. In 1964 a British band's American television debut here drew one of the largest TV audiences in history at the time.",
            imageAssetRef: "landmark_US_edsullivan",
            attribution: "Ed Sullivan Theater (1964) — Ajay Suresh from New York, NY, USA / Wikimedia Commons (CC BY 2.0)",
            answerType: .city, answerText: "New York",
            answerAliases: ["New York City", "NYC"]
        ),
        Landmark(
            id: "US_watergate", countryID: "US", name: "Watergate complex (1972)",
            eraFact: "North America. A 1972 break-in at this office-and-apartment complex set off a scandal that ultimately ended a presidency.",
            imageAssetRef: "landmark_US_watergate",
            attribution: "Watergate complex (1972) — PRRfan / Wikimedia Commons (CC BY-SA 4.0)",
            answerType: .city, answerText: "Washington, D.C.",
            answerAliases: ["Washington DC", "DC", "Washington"]
        ),
        Landmark(
            id: "PH_edsa", countryID: "PH", name: "EDSA (1986)",
            eraFact: "Asia. Millions filled this highway over four days in 1986 in a peaceful uprising that ended a two-decade presidency.",
            imageAssetRef: "landmark_PH_edsa",
            attribution: "EDSA (1986) — Ramon FVelasquez / Wikimedia Commons (CC BY-SA 3.0)",
            answerType: .city, answerText: "Manila",
            answerAliases: []
        ),
        Landmark(
            id: "US_graceland", countryID: "US", name: "Graceland",
            eraFact: "North America. This mansion was the longtime home of one of the best-selling solo music artists of all time, and is now his final resting place.",
            imageAssetRef: "landmark_US_graceland",
            attribution: "Graceland — Fallaner / Wikimedia Commons (CC BY-SA 4.0)",
            answerType: .city, answerText: "Memphis",
            answerAliases: []
        ),
        Landmark(
            id: "US_sunstudio", countryID: "US", name: "Sun Studio",
            eraFact: "North America. Regarded by many as the birthplace of rock and roll, this small studio recorded a string of soon-to-be-legendary musicians starting in the early 1950s.",
            imageAssetRef: "landmark_US_sunstudio",
            attribution: "Sun Studio — ant gorman / Wikimedia Commons (CC BY 2.0)",
            answerType: .city, answerText: "Memphis",
            answerAliases: []
        ),
        Landmark(
            id: "UA_pripyat", countryID: "UA", name: "Chernobyl/Pripyat (1986)",
            eraFact: "Europe. A nuclear reactor meltdown here in 1986 forced the permanent evacuation of a nearby city, now frozen in time.",
            imageAssetRef: "landmark_UA_pripyat",
            attribution: "Chernobyl/Pripyat (1986) — Omar David Sandoval Sida / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "GB_runnymede", countryID: "GB", name: "Runnymede (Magna Carta, 1215)",
            eraFact: "Europe. A meadow where, in 1215, a king was pressured into sealing a charter limiting royal power for the first time.",
            imageAssetRef: "landmark_GB_runnymede",
            attribution: "Runnymede (Magna Carta, 1215) — Wyrdlight / Wikimedia Commons (CC BY 3.0)"
        ),
        Landmark(
            id: "VN_independencepalace", countryID: "VN", name: "Fall of Saigon (1975)",
            eraFact: "Asia. In 1975 the capital of a former southern republic fell as the last foreign personnel were airlifted from its rooftops, marking a war's end.",
            imageAssetRef: "landmark_VN_independencepalace",
            attribution: "Fall of Saigon (1975) — Balon Greyjoy / Wikimedia Commons (CC0)"
        ),
        Landmark(
            id: "CD_stadetata", countryID: "CD", name: "Rumble in the Jungle (1974)",
            eraFact: "Africa. In 1974 this city hosted a heavyweight boxing match staged in the middle of the night to suit live American TV audiences, later called one of the greatest sporting events of the century.",
            imageAssetRef: "landmark_CD_stadetata",
            attribution: "Rumble in the Jungle (1974) — Yallahbye / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "UG_entebbe", countryID: "UG", name: "Entebbe (1976 raid)",
            eraFact: "Africa. In 1976 commandos flew thousands of kilometers to stage a night raid at this airport, freeing hostages from a hijacked airliner.",
            imageAssetRef: "landmark_UG_entebbe",
            attribution: "Entebbe (1976 raid) — Wikivoyage user Katanasov / Wikimedia Commons (Public domain)"
        ),
        Landmark(
            id: "TH_riverkwai", countryID: "TH", name: "Bridge on the River Kwai",
            eraFact: "Asia. Prisoners of war were forced to build a railway bridge here during the Second World War, later the subject of a famous film.",
            imageAssetRef: "landmark_TH_riverkwai",
            attribution: "Bridge on the River Kwai — PumpkinSky / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "IN_jallianwala", countryID: "IN", name: "Jallianwala Bagh (1919)",
            eraFact: "Asia. In 1919 troops opened fire on an unarmed crowd gathered in this walled garden, a massacre that galvanized an independence movement.",
            imageAssetRef: "landmark_IN_jallianwala",
            attribution: "Jallianwala Bagh (1919) — Bernard Gagnon / Wikimedia Commons (CC BY-SA 4.0)"
        ),
        Landmark(
            id: "CU_bayofpigs", countryID: "CU", name: "Bay of Pigs (1961)",
            eraFact: "North America. In 1961 an exile force backed by a foreign government landed on these beaches in a failed attempt to overthrow the country's new leadership.",
            imageAssetRef: "landmark_CU_bayofpigs",
            attribution: "Bay of Pigs (1961) — Bibit / Wikimedia Commons (CC BY-SA 3.0)"
        ),
        Landmark(
            id: "ZA_robbenisland", countryID: "ZA", name: "Robben Island",
            eraFact: "Africa. A future president spent 18 of his 27 years in prison on this island before his release helped end a system of racial segregation.",
            imageAssetRef: "landmark_ZA_robbenisland",
            attribution: "Robben Island — South African Tourism from South Africa / Wikimedia Commons (CC BY 2.0)"
        ),
        Landmark(
            id: "US_alamo", countryID: "US", name: "The Alamo (1836)",
            eraFact: "North America. A 13-day siege at this mission-turned-fort in 1836 ended with nearly all its defenders killed, becoming a rallying cry for the independence movement that followed.",
            imageAssetRef: "landmark_US_alamo",
            attribution: "The Alamo (1836) — Daniel Schwen / Wikimedia Commons (CC BY-SA 4.0)",
            answerType: .state, answerText: "Texas",
            answerAliases: ["TX"]
        ),
        Landmark(
            id: "US_pearlharbor", countryID: "US", name: "Pearl Harbor (1941)",
            eraFact: "North America. A surprise naval attack here in 1941 brought the country into the Second World War the very next day.",
            imageAssetRef: "landmark_US_pearlharbor",
            attribution: "Pearl Harbor (1941) — DoD photo by: PH3(AW/SW) JAYME PASTORIC, USN / Wikimedia Commons (Public domain)",
            answerType: .placename, answerText: "Pearl Harbor",
            answerAliases: []
        ),
        Landmark(
            id: "US_woodstock", countryID: "US", name: "Woodstock (1969)",
            eraFact: "North America. Half a million people gathered on a dairy farm for three days of music in 1969, becoming a defining moment of a cultural generation.",
            imageAssetRef: "landmark_US_woodstock",
            attribution: "Woodstock (1969) — Seanbarnett / Wikimedia Commons (CC BY-SA 4.0)",
            answerType: .placename, answerText: "Woodstock",
            answerAliases: []
        ),
        Landmark(
            id: "US_capecanaveral", countryID: "US", name: "Cape Canaveral (Apollo missions)",
            eraFact: "North America. Nearly every crewed Moon mission launched from this stretch of Florida coastline, including the first crewed Moon landing in 1969.",
            imageAssetRef: "landmark_US_capecanaveral",
            attribution: "Cape Canaveral (Apollo missions) — Kim Shiflett / Wikimedia Commons (Public domain)",
            answerType: .placename, answerText: "Cape Canaveral",
            answerAliases: ["Kennedy Space Center", "Canaveral"]
        ),
    ]
}
