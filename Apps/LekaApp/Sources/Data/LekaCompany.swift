// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Foundation

class LekaCompany {
    // This will only be used for tests + maybe congresses??
    let lekaCompany = Company(
        mail: "test@leka.io",
        password: "lekaleka",
        teachers: [
            Teacher(
                name: "Ladislas",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsBananaYellow00FB.name,
                jobs: ["CEO"]
            ),
            Teacher(
                name: "Hortense",
                avatar: DesignKitAsset.Avatars.avatarsLekaExplorer.name,
                jobs: ["Designer"]
            ),
            Teacher(
                name: "Lucie",
                avatar: DesignKitAsset.Avatars.avatarsLekaGirl6a.name,
                jobs: ["COO"]
            ),
            Teacher(
                name: "Mathieu",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaCrabRed003E.name,
                jobs: ["Developer"]
            ),
            Teacher(
                name: "Jean-Christophe B.",
                avatar: DesignKitAsset.Avatars.avatarsLekaMoon.name,
                jobs: ["Pédopsychiatre"]
            ),
        ],
        users: [
            User(
                name: "Alice",
                avatar: DesignKitAsset.Avatars.avatarsLekaSunglassesBlue.name,
                reinforcer: 3
            ),
            User(
                name: "Olivia",
                avatar: DesignKitAsset.Avatars.avatarsLekaStar.name,
                reinforcer: 5
            ),
            User(
                name: "Elessa",
                avatar: DesignKitAsset.Avatars.avatarsGirl3e62.name,
                reinforcer: 1
            ),
            User(
                name: "Lucas",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsFarmRoosterWhite006B.name,
                reinforcer: 2
            ),
            User(
                name: "Maximilien",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesCornYellow00E3.name,
                reinforcer: 4
            ),
            User(
                name: "Stéphane",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaTurtleGreen0041.name,
                reinforcer: 3
            ),
            User(
                name: "Lila",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaCrabRed003E.name,
                reinforcer: 2
            ),
            User(
                name: "Pierre",
                avatar: DesignKitAsset.Avatars.avatarsBoy2d.name,
                reinforcer: 1
            ),
            User(
                name: "Baptiste",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestHedgehogBrown0062.name,
                reinforcer: 5
            ),
            User(
                name: "Éloïse",
                avatar: DesignKitAsset.Avatars.avatarsSun.name,
                reinforcer: 4
            ),
            User(
                name: "Clément",
                avatar: DesignKitAsset.Avatars.avatarsLekaBoy2d.name,
                reinforcer: 2
            ),
            User(
                name: "Simon",
                avatar: DesignKitAsset.Avatars.avatarsLekaMarine.name,
                reinforcer: 3
            ),
            User(
                name: "Jean-Pierre Marie",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsStrawberryRed00FD.name,
                reinforcer: 4
            ),
        ]
    )

}
