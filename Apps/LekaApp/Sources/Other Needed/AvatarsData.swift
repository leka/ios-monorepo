//
    //  AvatarsData.swift
    //  LekaTestBucket
    //
    //  Created by Mathieu Jeannot on 12/1/23.
    //

import Foundation

    // Avatar Picker Models
struct AvatarCategory: Identifiable, Hashable {
    let id = UUID()
    let category: String
    let images: [String]
}

    // AvatarPicker Data
enum AvatarSets: Int, CaseIterable, Hashable {
    case girls, boys, lekaGirls, lekaBoys, jobs, weather, sunglasses, animals, fruits, vegies

    var id: Self { self }

    var content: AvatarCategory {
        switch self {
            case .girls: return AvatarCategory(category: "Filles", images: ["avatars_girl-1a",
                                                                            "avatars_girl-1b",
                                                                            "avatars_girl-1c",
                                                                            "avatars_girl-1d",
                                                                            "avatars_girl-1e",
                                                                            "avatars_girl-1f",
                                                                            "avatars_girl-2a",
                                                                            "avatars_girl-2b",
                                                                            "avatars_girl-2c",
                                                                            "avatars_girl-2d",
                                                                            "avatars_girl-2e",
                                                                            "avatars_girl-2f",
                                                                            "avatars_girl-3a",
                                                                            "avatars_girl-3b",
                                                                            "avatars_girl-3c",
                                                                            "avatars_girl-3d",
                                                                            "avatars_girl-3e-62",
                                                                            "avatars_girl-3e-97",
                                                                            "avatars_girl-4a",
                                                                            "avatars_girl-4b",
                                                                            "avatars_girl-4c",
                                                                            "avatars_girl-4d",
                                                                            "avatars_girl-4e",
                                                                            "avatars_girl-5a",
                                                                            "avatars_girl-5b",
                                                                            "avatars_girl-5c",
                                                                            "avatars_girl-5d",
                                                                            "avatars_girl-5e"])
            case .boys: return AvatarCategory(category: "Garçons", images: ["avatars_boy-1a",
                                                                            "avatars_boy-1b",
                                                                            "avatars_boy-1c-75",
                                                                            "avatars_boy-1d-76",
                                                                            "avatars_boy-1e",
                                                                            "avatars_boy-1f",
                                                                            "avatars_boy-1g",
                                                                            "avatars_boy-2a",
                                                                            "avatars_boy-2b",
                                                                            "avatars_boy-2c",
                                                                            "avatars_boy-2d",
                                                                            "avatars_boy-2e-82",
                                                                            "avatars_boy-2e-115",
                                                                            "avatars_boy-2f",
                                                                            "avatars_boy-2g",
                                                                            "avatars_boy-3a",
                                                                            "avatars_boy-3b",
                                                                            "avatars_boy-3c",
                                                                            "avatars_boy-3d",
                                                                            "avatars_boy-3e",
                                                                            "avatars_boy-3f",
                                                                            "avatars_boy-3g",
                                                                            "avatars_boy-4a",
                                                                            "avatars_boy-4b",
                                                                            "avatars_boy-4c",
                                                                            "avatars_boy-4d",
                                                                            "avatars_boy-4e",
                                                                            "avatars_boy-4f",
                                                                            "avatars_boy-4g"])
            case .lekaGirls: return AvatarCategory(category: "Filles Leka", images: ["avatars_leka-girl-1a",
                                                                                     "avatars_leka-girl-1b",
                                                                                     "avatars_leka-girl-1c-118",
                                                                                     "avatars_leka-girl-1c-119",
                                                                                     "avatars_leka-girl-2a",
                                                                                     "avatars_leka-girl-2b",
                                                                                     "avatars_leka-girl-2c",
                                                                                     "avatars_leka-girl-2d",
                                                                                     "avatars_leka-girl-3a",
                                                                                     "avatars_leka-girl-3b",
                                                                                     "avatars_leka-girl-3c",
                                                                                     "avatars_leka-girl-3d",
                                                                                     "avatars_leka-girl-4a",
                                                                                     "avatars_leka-girl-4b",
                                                                                     "avatars_leka-girl-4c",
                                                                                     "avatars_leka-girl-4d",
                                                                                     "avatars_leka-girl-5a",
                                                                                     "avatars_leka-girl-5b",
                                                                                     "avatars_leka-girl-5c",
                                                                                     "avatars_leka-girl-5d",
                                                                                     "avatars_leka-girl-6a",
                                                                                     "avatars_leka-girl-6b",
                                                                                     "avatars_leka-girl-6c",
                                                                                     "avatars_leka-girl-6d"])
            case .lekaBoys: return AvatarCategory(category: "Garçons Leka", images: ["avatars_leka-boy-1a",
                                                                                     "avatars_leka-boy-1b",
                                                                                     "avatars_boy-1c-138",
                                                                                     "avatars_boy-1d-144",
                                                                                     "avatars_leka-boy-2a",
                                                                                     "avatars_leka-boy-2b",
                                                                                     "avatars_leka-boy-2c",
                                                                                     "avatars_leka-boy-2d"])
            case .jobs: return AvatarCategory(category: "Métiers Leka", images: ["avatars_leka_cook",
                                                                                 "avatars_leka_astronaut",
                                                                                 "avatars_leka_doctor",
                                                                                 "avatars_leka_explorer",
                                                                                 "avatars_leka_marine",
                                                                                 "avatars_leka_pirate"])
            case .weather: return AvatarCategory(category: "Météo Leka", images: ["avatars_leka_cloud",
                                                                                  "avatars_leka_flake",
                                                                                  "avatars_leka_moon",
                                                                                  "avatars_leka_star",
                                                                                  "avatars_sun"])
            case .sunglasses: return AvatarCategory(category: "Lunettes de soleil", images: ["avatars_leka_sunglasses_blue",
                                                                                             "avatars_leka_sunglasses_green",
                                                                                             "avatars_leka_sunglasses_yellow",
                                                                                             "avatars_leka_sunglasses_pink"])
            case .animals: return AvatarCategory(category: "Animaux", images: ["avatars_pictograms-animals-farm-bird_yellow-0071",
                                                                               "avatars_pictograms-animals-farm-horse_brown-006A",
                                                                               "avatars_pictograms-animals-farm-rooster_white-006B",
                                                                               "avatars_pictograms-animals-forest-bear_brown-005E",
                                                                               "avatars_pictograms-animals-forest-fox_orange-0064",
                                                                               "avatars_pictograms-animals-forest-hedgehog_brown-0062",
                                                                               "avatars_pictograms-animals-forest-rabbit_gray-0061",
                                                                               "avatars_pictograms-animals-forest-squirrel_orange-005C",
                                                                               "avatars_pictograms-animals-pets_fish_blue-0055",
                                                                               "avatars_pictograms-animals-pets-turtle_green-0056",
                                                                               "avatars_pictograms-animals-savanna-elephant_gray-0085",
                                                                               "avatars_pictograms-animals-savanna-giraffe_yellow-0081",
                                                                               "avatars_pictograms-animals-savanna-kangaroo_brown-0078",
                                                                               "avatars_pictograms-animals-savanna-koala_gray-0077",
                                                                               "avatars_pictograms-animals-savanna-lion_brown-0082",
                                                                               "avatars_pictograms-animals-sea-crab_red-003E",
                                                                               "avatars_pictograms-animals-sea-turtle_green-0041"])
            case .fruits: return AvatarCategory(category: "Fruits", images: ["avatars_pictograms-foods-fruits-apple_green-0100",
                                                                             "avatars_pictograms-foods-fruits-apple_red-0101",
                                                                             "avatars_pictograms-foods-fruits-banana_yellow-00FB",
                                                                             "avatars_pictograms-foods-fruits-cherry_red-00FF",
                                                                             "avatars_pictograms-foods-fruits-grape_purple-00FE",
                                                                             "avatars_pictograms-foods-fruits-kiwi_green-00F8",
                                                                             "avatars_pictograms-foods-fruits-lemon_yellow-00F7",
                                                                             "avatars_pictograms-foods-fruits-pear_yellow-00FC",
                                                                             "avatars_pictograms-foods-fruits-pineapple_orange-00F9",
                                                                             "avatars_pictograms-foods-fruits-strawberry_red-00FD",
                                                                             "avatars_pictograms-foods-fruits-watermelon_red-00FA"])
            case .vegies: return AvatarCategory(category: "Légumes", images: ["avatars_pictograms-foods-vegetables-avocado_green-00E1",
                                                                              "avatars_pictograms-foods-vegetables-broccoli_green-00E5",
                                                                              "avatars_pictograms-foods-vegetables-carrot_orange-00E6",
                                                                              "avatars_pictograms-foods-vegetables-corn_yellow-00E3",
                                                                              "avatars_pictograms-foods-vegetables-eggplant_purple-00E4",
                                                                              "avatars_pictograms-foods-vegetables-onion_yellow-00E8",
                                                                              "avatars_pictograms-foods-vegetables-potato_yellow_1-00E9",
                                                                              "avatars_pictograms-foods-vegetables-salad_green_1-00EA",
                                                                              "avatars_pictograms-foods-vegetables-tomato_red-00E2"])
        }
    }
}
