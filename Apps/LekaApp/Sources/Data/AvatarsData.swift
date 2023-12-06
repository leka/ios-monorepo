// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Foundation

// MARK: - AvatarCategory

// Avatar Picker Models
struct AvatarCategory: Identifiable, Hashable {
    let id = UUID()
    let category: String
    let images: [String]
}

// MARK: - AvatarSets

// AvatarPicker Data
enum AvatarSets: Int, CaseIterable, Hashable {
    case girls, boys, lekaGirls, lekaBoys, jobs, weather, sunglasses, animals, fruits, vegies

    var id: Self { self }

    var content: AvatarCategory {
        switch self {
            case .girls:
                return AvatarCategory(
                    category: "Filles",
                    images: [
                        DesignKitAsset.Avatars.avatarsGirl1a.name,
                        DesignKitAsset.Avatars.avatarsGirl1b.name,
                        DesignKitAsset.Avatars.avatarsGirl1c.name,
                        DesignKitAsset.Avatars.avatarsGirl1d.name,
                        DesignKitAsset.Avatars.avatarsGirl1e.name,
                        DesignKitAsset.Avatars.avatarsGirl1f.name,
                        DesignKitAsset.Avatars.avatarsGirl2a.name,
                        DesignKitAsset.Avatars.avatarsGirl2b.name,
                        DesignKitAsset.Avatars.avatarsGirl2c.name,
                        DesignKitAsset.Avatars.avatarsGirl2d.name,
                        DesignKitAsset.Avatars.avatarsGirl2e.name,
                        DesignKitAsset.Avatars.avatarsGirl2f.name,
                        DesignKitAsset.Avatars.avatarsGirl3a.name,
                        DesignKitAsset.Avatars.avatarsGirl3b.name,
                        DesignKitAsset.Avatars.avatarsGirl3c.name,
                        DesignKitAsset.Avatars.avatarsGirl3d.name,
                        DesignKitAsset.Avatars.avatarsGirl3e62.name,
                        DesignKitAsset.Avatars.avatarsGirl3e97.name,
                        DesignKitAsset.Avatars.avatarsGirl4a.name,
                        DesignKitAsset.Avatars.avatarsGirl4b.name,
                        DesignKitAsset.Avatars.avatarsGirl4c.name,
                        DesignKitAsset.Avatars.avatarsGirl4d.name,
                        DesignKitAsset.Avatars.avatarsGirl4e.name,
                        DesignKitAsset.Avatars.avatarsGirl5a.name,
                        DesignKitAsset.Avatars.avatarsGirl5b.name,
                        DesignKitAsset.Avatars.avatarsGirl5c.name,
                        DesignKitAsset.Avatars.avatarsGirl5d.name,
                        DesignKitAsset.Avatars.avatarsGirl5e.name,
                    ])
            case .boys:
                return AvatarCategory(
                    category: "Garçons",
                    images: [
                        DesignKitAsset.Avatars.avatarsBoy1a.name,
                        DesignKitAsset.Avatars.avatarsBoy1b.name,
                        DesignKitAsset.Avatars.avatarsBoy1c75.name,
                        DesignKitAsset.Avatars.avatarsBoy1d76.name,
                        DesignKitAsset.Avatars.avatarsBoy1e.name,
                        DesignKitAsset.Avatars.avatarsBoy1f.name,
                        DesignKitAsset.Avatars.avatarsBoy1g.name,
                        DesignKitAsset.Avatars.avatarsBoy2a.name,
                        DesignKitAsset.Avatars.avatarsBoy2b.name,
                        DesignKitAsset.Avatars.avatarsBoy2c.name,
                        DesignKitAsset.Avatars.avatarsBoy2d.name,
                        DesignKitAsset.Avatars.avatarsBoy2e82.name,
                        DesignKitAsset.Avatars.avatarsBoy2e115.name,
                        DesignKitAsset.Avatars.avatarsBoy2f.name,
                        DesignKitAsset.Avatars.avatarsBoy2g.name,
                        DesignKitAsset.Avatars.avatarsBoy3a.name,
                        DesignKitAsset.Avatars.avatarsBoy3b.name,
                        DesignKitAsset.Avatars.avatarsBoy3c.name,
                        DesignKitAsset.Avatars.avatarsBoy3d.name,
                        DesignKitAsset.Avatars.avatarsBoy3e.name,
                        DesignKitAsset.Avatars.avatarsBoy3f.name,
                        DesignKitAsset.Avatars.avatarsBoy3g.name,
                        DesignKitAsset.Avatars.avatarsBoy4a.name,
                        DesignKitAsset.Avatars.avatarsBoy4b.name,
                        DesignKitAsset.Avatars.avatarsBoy4c.name,
                        DesignKitAsset.Avatars.avatarsBoy4d.name,
                        DesignKitAsset.Avatars.avatarsBoy4e.name,
                        DesignKitAsset.Avatars.avatarsBoy4f.name,
                        DesignKitAsset.Avatars.avatarsBoy4g.name,
                    ])
            case .lekaGirls:
                return AvatarCategory(
                    category: "Filles Leka",
                    images: [
                        DesignKitAsset.Avatars.avatarsLekaGirl1a.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl1b.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl1c118.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl1c119.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl2a.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl2b.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl2c.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl2d.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl3a.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl3b.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl3c.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl3d.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl4a.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl4b.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl4c.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl4d.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl5a.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl5b.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl5c.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl5d.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl6a.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl6b.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl6c.name,
                        DesignKitAsset.Avatars.avatarsLekaGirl6d.name,
                    ])
            case .lekaBoys:
                return AvatarCategory(
                    category: "Garçons Leka",
                    images: [
                        DesignKitAsset.Avatars.avatarsLekaBoy1a.name,
                        DesignKitAsset.Avatars.avatarsLekaBoy1b.name,
                        DesignKitAsset.Avatars.avatarsBoy1c138.name,
                        DesignKitAsset.Avatars.avatarsBoy1d144.name,
                        DesignKitAsset.Avatars.avatarsLekaBoy2a.name,
                        DesignKitAsset.Avatars.avatarsLekaBoy2b.name,
                        DesignKitAsset.Avatars.avatarsLekaBoy2c.name,
                        DesignKitAsset.Avatars.avatarsLekaBoy2d.name,
                    ])
            case .jobs:
                return AvatarCategory(
                    category: "Métiers Leka",
                    images: [
                        DesignKitAsset.Avatars.avatarsLekaCook.name,
                        DesignKitAsset.Avatars.avatarsLekaAstronaut.name,
                        DesignKitAsset.Avatars.avatarsLekaDoctor.name,
                        DesignKitAsset.Avatars.avatarsLekaExplorer.name,
                        DesignKitAsset.Avatars.avatarsLekaMarine.name,
                        DesignKitAsset.Avatars.avatarsLekaPirate.name,
                    ])
            case .weather:
                return AvatarCategory(
                    category: "Météo Leka",
                    images: [
                        DesignKitAsset.Avatars.avatarsLekaCloud.name,
                        DesignKitAsset.Avatars.avatarsLekaFlake.name,
                        DesignKitAsset.Avatars.avatarsLekaMoon.name,
                        DesignKitAsset.Avatars.avatarsLekaStar.name,
                        DesignKitAsset.Avatars.avatarsSun.name,
                    ])
            case .sunglasses:
                return AvatarCategory(
                    category: "Lunettes de soleil",
                    images: [
                        DesignKitAsset.Avatars.avatarsLekaSunglassesBlue.name,
                        DesignKitAsset.Avatars.avatarsLekaSunglassesGreen.name,
                        DesignKitAsset.Avatars.avatarsLekaSunglassesYellow.name,
                        DesignKitAsset.Avatars.avatarsLekaSunglassesPink.name,
                    ])
            case .animals:
                return AvatarCategory(
                    category: "Animaux",
                    images: [
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsFarmBirdYellow0071.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsFarmHorseBrown006A.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsFarmRoosterWhite006B.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestBearBrown005E.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestFoxOrange0064.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestHedgehogBrown0062.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestRabbitGray0061.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestSquirrelOrange005C.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsPetsFishBlue0055.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsPetsTurtleGreen0056.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsSavannaElephantGray0085.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsSavannaGiraffeYellow0081.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsSavannaKangarooBrown0078.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsSavannaKoalaGray0077.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsSavannaLionBrown0082.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaCrabRed003E.name,
                        DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaTurtleGreen0041.name,
                    ])
            case .fruits:
                return AvatarCategory(
                    category: "Fruits",
                    images: [
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsAppleGreen0100.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsAppleRed0101.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsBananaYellow00FB.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsCherryRed00FF.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsGrapePurple00FE.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsKiwiGreen00F8.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsLemonYellow00F7.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsPearYellow00FC.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsPineappleOrange00F9.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsStrawberryRed00FD.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsWatermelonRed00FA.name,
                    ])
            case .vegies:
                return AvatarCategory(
                    category: "Légumes",
                    images: [
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesAvocadoGreen00E1.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesBroccoliGreen00E5.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesCarrotOrange00E6.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesCornYellow00E3.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesEggplantPurple00E4.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesOnionYellow00E8.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesPotatoYellow100E9.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesSaladGreen100EA.name,
                        DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesTomatoRed00E2.name,
                    ])
        }
    }
}
