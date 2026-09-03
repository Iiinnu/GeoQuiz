import Foundation

/// Hand-picked geography/culture facts, one per country, used to enrich Hint 2 across all
/// 5 modes (see `HintProvider`) — the same fact is reused regardless of mode, since it's a
/// property of the country itself, not something mode-specific. Deliberately avoids naming
/// the country/capital/city directly, and avoids anything visible in Flags' own image (a
/// flag's colors or symbols would just restate what's already on screen) or a landmark
/// whose name alone gives away the country (e.g. "the pyramids" for Egypt).
enum CountryFunFacts {
    static let all: [String: String] = [
        // North America
        "US": "It has the world's largest economy by GDP.",
        "CA": "It has the world's longest international land border with another country.",
        "MX": "It's home to more Spanish speakers than any other country in the world.",
        "CU": "Classic American cars from the 1950s are still a common sight on its streets, kept running for decades under a long trade embargo.",

        // South America
        "AR": "It's home to what's often called the world's widest avenue, in its capital.",
        "BR": "It's the largest country in South America by both area and population.",
        "CL": "It's one of the longest, narrowest countries in the world — over 4,000km from top to bottom.",
        "CO": "It's the world's second most biodiverse country, despite not being the largest.",
        "PE": "It's home to a UNESCO World Heritage citadel high in the Andes.",
        "VE": "It's home to the world's tallest waterfall.",
        "EC": "It's named after the imaginary line that runs through it.",
        "UY": "It was the first country in the world to legalize cannabis production and sale nationwide.",
        "BO": "It's home to the world's largest salt flat.",

        // Europe
        "FR": "It's the most visited country in the world by international tourists.",
        "DE": "It has no overall speed limit on much of its highway network.",
        "IT": "It has more UNESCO World Heritage Sites than any other country.",
        "GB": "It's made up of four constituent nations under one government.",
        "RU": "It's the largest country in the world by area, spanning 11 time zones.",
        "AT": "It's the birthplace of several of the world's most famous classical composers.",
        "BE": "It's home to more castles per square kilometer than almost anywhere else in the world.",
        "BG": "It's one of the oldest countries in Europe, with a history under the same name dating back over 1,300 years.",
        "HR": "Its coastline has over a thousand islands along the Adriatic Sea.",
        "CY": "It's the third-largest and third-most populous island in the Mediterranean.",
        "CZ": "It's home to one of the largest ancient castle complexes in the world.",
        "DK": "It's consistently ranked among the happiest countries in the world.",
        "EE": "It's one of the most digitally advanced countries in the world — you can even vote online.",
        "FI": "It has more saunas than cars.",
        "GR": "It's often called the birthplace of democracy.",
        "HU": "Its capital is home to one of the largest thermal bath complexes in Europe.",
        "IE": "It's known as the Emerald Isle for its lush green countryside.",
        "LV": "Its capital's historic center is a UNESCO World Heritage Site known for Art Nouveau architecture.",
        "LT": "It was the first Soviet republic to declare independence, in 1990.",
        "LU": "It's one of the smallest countries in Europe, yet one of the wealthiest per capita.",
        "MT": "It's one of the smallest and most densely populated countries in the world.",
        "NL": "About a quarter of its land lies below sea level.",
        "PL": "It's home to one of the largest and oldest salt mines in the world, dug over 700 years ago.",
        "PT": "It's the oldest country in Europe with unchanged borders, dating back to the 1200s.",
        "RO": "It's home to one of the largest palaces in the world by floor area.",
        "SK": "It has one of the highest densities of castles of any country in the world.",
        "SI": "More than half of its land is covered by forest.",
        "ES": "It's home to more UNESCO World Heritage Sites than almost any other country.",
        "SE": "It has more than 100,000 islands along its coastline.",
        "NO": "It's home to some of the longest and deepest fjords in the world.",
        "CH": "It borders five other countries but has no coastline at all.",
        "UA": "It's the largest country whose territory lies entirely within Europe.",

        // Asia
        "CN": "It shares land borders with more countries than any other nation on Earth — 14 in total.",
        "IN": "It's home to the largest film industry in the world by number of films produced each year.",
        "ID": "It's made up of more than 17,000 islands — the largest archipelago in the world.",
        "JP": "It's made up of nearly 7,000 islands.",
        "SA": "It's the largest country in the world with no permanent rivers or lakes.",
        "KR": "It's one of the most densely populated countries in the world, and a global leader in internet speed.",
        "TR": "It's one of the few countries that spans two continents, with a city split between them.",
        "TH": "It's the only country in Southeast Asia never colonized by a European power.",
        "VN": "It's the world's second-largest coffee exporter, after Brazil.",
        "PH": "It's made up of more than 7,000 islands.",
        "PK": "It's home to some of the highest mountain peaks outside of Everest.",
        "IL": "It's home to the lowest point on Earth's land surface.",
        "IR": "It's home to one of the oldest continuous civilizations in the world.",
        "MY": "It's home to twin towers that were once the tallest buildings in the world.",
        "SG": "It's one of only a few surviving city-states in the world.",
        "BD": "It has one of the highest population densities of any country in the world.",
        "LK": "It was home to the world's first female head of government.",
        "AE": "It's home to the tallest building in the world.",
        "MN": "It has the lowest population density of any independent country in the world.",

        // Africa
        "ZA": "It has three separate capital cities.",
        "EG": "It's home to the only Ancient Wonder of the World still standing.",
        "NG": "It's the most populous country in Africa.",
        "KE": "Its long-distance runners have won more Olympic medals than almost any other nation's.",
        "MA": "It's separated from Europe by a strait just 14 kilometers wide at its narrowest point.",
        "DZ": "It's the largest country in Africa by land area.",
        "ET": "It's one of the only African countries never colonized by a European power.",
        "GH": "It was the first country in sub-Saharan Africa to gain independence from colonial rule.",
        "TZ": "It's home to Africa's highest mountain.",
        "ZW": "It's home to one of the largest waterfalls in the world.",
        "SN": "It's home to the westernmost point of mainland Africa.",
        "CD": "It's home to the world's second-largest rainforest.",
        "UG": "It's home to the source of the world's longest river.",

        // Oceania
        "AU": "It's the only country that's also an entire continent.",
        "NZ": "It's one of the first places in the world to welcome each new year.",
    ]
}
