// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

class DiscoveryCompany {
    static var discoveryTeachers: [Teacher] =
        [
            Teacher(
                name: "Aurore",
                avatar: DesignKitAsset.Avatars.avatarsLekaCook.name,
                jobs: ["Psychomotricien(ne)"]
            ),
            Teacher(
                name: "Jean-Louis",
                avatar: DesignKitAsset.Avatars.accompanyingBlue.name,
                jobs: ["Psychomotricien(ne)"]
            ),
            Teacher(
                name: "Pauline",
                avatar: DesignKitAsset.Avatars.avatarsLekaExplorer.name,
                jobs: ["Ergothérapeute"]
            ),
            Teacher(
                name: "Jean-Pierre",
                avatar: DesignKitAsset.Avatars.avatarsBoy3c.name,
                jobs: ["Pédopsychiatre"]
            ),
            Teacher(
                name: "Anne",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsPineappleOrange00F9.name,
                jobs: ["Accompagnant(e) des élèves en situation de handicap"]
            ),
        ]

    static var discoveryUsers: [User] =
        [
            User(
                name: "Alice",
                avatar: DesignKitAsset.Avatars.avatarsGirl1a.name,
                reinforcer: 3
            ),
            User(
                name: "Olivia",
                avatar: DesignKitAsset.Avatars.avatarsLekaSunglassesBlue.name,
                reinforcer: 5
            ),
            User(
                name: "Alexandre",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestHedgehogBrown0062.name,
                reinforcer: 1
            ),
            User(
                name: "Érica",
                avatar: DesignKitAsset.Avatars.avatarsLekaMoon.name,
                reinforcer: 4
            ),
            User(
                name: "Elessa",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsFarmBirdYellow0071.name,
                reinforcer: 1
            ),
            User(
                name: "Lucas",
                avatar: DesignKitAsset.Avatars.avatarsBoy1d144.name,
                reinforcer: 2
            ),
            User(
                name: "Sébastien",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestSquirrelOrange005C.name,
                reinforcer: 1
            ),
            User(
                name: "Maximilien",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsCherryRed00FF.name,
                reinforcer: 4
            ),
            User(
                name: "Luc",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestFoxOrange0064.name,
                reinforcer: 1
            ),
            User(
                name: "Élisabeth",
                avatar: DesignKitAsset.Avatars.avatarsSun.name,
                reinforcer: 5
            ),
            User(
                name: "Ariane",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSavannaGiraffeYellow0081.name,
                reinforcer: 1
            ),
            User(
                name: "Stéphane",
                avatar: DesignKitAsset.Avatars.avatarsBoy4c.name,
                reinforcer: 3
            ),
            User(
                name: "Lila",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsVegetablesCarrotOrange00E6.name,
                reinforcer: 2
            ),
            User(
                name: "Pierre",
                avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSavannaLionBrown0082.name,
                reinforcer: 1
            ),
            User(
                name: "Baptiste",
                avatar: DesignKitAsset.Avatars.avatarsBoy2d.name,
                reinforcer: 5
            ),
            User(
                name: "Éloïse",
                avatar: DesignKitAsset.Avatars.avatarsGirl2d.name,
                reinforcer: 4
            ),
            User(
                name: "Clément",
                avatar: DesignKitAsset.Avatars.avatarsLekaMoon.name,
                reinforcer: 2
            ),
            User(
                name: "Simon",
                avatar: DesignKitAsset.Avatars.avatarsLekaMarine.name,
                reinforcer: 3
            ),
        ]

    let discoveryCompany = Company(
        mail: "discovery@leka.io", password: "Password1234", teachers: discoveryTeachers, users: discoveryUsers
    )
}
