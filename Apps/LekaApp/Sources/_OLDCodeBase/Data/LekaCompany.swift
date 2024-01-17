// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Foundation

class LekaCompany {
    // This will only be used for tests + maybe congresses??
    let lekaCompany = CompanyDeprecated(
        mail: "test@leka.io",
        password: "lekaleka",
        teachers: [
            TeacherDeprecated(
                name: "Ladislas",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsBananaYellow00FB.name,
                jobs: ["CEO"]
            ),
            TeacherDeprecated(
                name: "Hortense",
                avatar: DesignKitAsset.Avatars.avatarsLekaExplorer.name,
                jobs: ["Designer"]
            ),
            TeacherDeprecated(
                name: "Lucie",
                avatar: DesignKitAsset.Avatars.avatarsLekaGirl6a.name,
                jobs: ["COO"]
            ),
            TeacherDeprecated(
                name: "Mathieu",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaCrabRed003E.name,
                jobs: ["Developer"]
            ),
            TeacherDeprecated(
                name: "Jean-Christophe B.",
                avatar: DesignKitAsset.Avatars.avatarsLekaMoon.name,
                jobs: ["Pédopsychiatre"]
            ),
        ],
        users: [
            UserDeprecated(
                name: "Alice",
                avatar: DesignKitAsset.Avatars.avatarsLekaSunglassesBlue.name,
                reinforcer: 3
            ),
            UserDeprecated(
                name: "Olivia",
                avatar: DesignKitAsset.Avatars.avatarsLekaStar.name,
                reinforcer: 5
            ),
            UserDeprecated(
                name: "Elessa",
                avatar: DesignKitAsset.Avatars.avatarsGirl3e62.name,
                reinforcer: 1
            ),
            UserDeprecated(
                name: "Lucas",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsFarmRoosterWhite006B.name,
                reinforcer: 2
            ),
            UserDeprecated(
                name: "Maximilien",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesCornYellow00E3.name,
                reinforcer: 4
            ),
            UserDeprecated(
                name: "Stéphane",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaTurtleGreen0041.name,
                reinforcer: 3
            ),
            UserDeprecated(
                name: "Lila",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaCrabRed003E.name,
                reinforcer: 2
            ),
            UserDeprecated(
                name: "Pierre",
                avatar: DesignKitAsset.Avatars.avatarsBoy2d.name,
                reinforcer: 1
            ),
            UserDeprecated(
                name: "Baptiste",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestHedgehogBrown0062.name,
                reinforcer: 5
            ),
            UserDeprecated(
                name: "Éloïse",
                avatar: DesignKitAsset.Avatars.avatarsSun.name,
                reinforcer: 4
            ),
            UserDeprecated(
                name: "Clément",
                avatar: DesignKitAsset.Avatars.avatarsLekaBoy2d.name,
                reinforcer: 2
            ),
            UserDeprecated(
                name: "Simon",
                avatar: DesignKitAsset.Avatars.avatarsLekaMarine.name,
                reinforcer: 3
            ),
            UserDeprecated(
                name: "Jean-Pierre Marie",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsStrawberryRed00FD.name,
                reinforcer: 4
            ),
        ]
    )
}
