// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Foundation
import SwiftUI

// swiftlint:disable line_length

struct TileContent {
    var image: String?
    var title: String?
    var subtitle: String?
    var message: String?
    var callToActionLabel: String?
    var pictoCTA: String?
}

enum TileData: Int, CaseIterable, Hashable {
    case discovery, curriculums, activities, commands
    case signupBravo, signupStep1, signupStep2, signupFinalStep

    var id: Self { self }

    var content: TileContent {
        switch self {
            // DiscoveryMode Orange Tile
            case .discovery:
                return TileContent(
                    image: "exclamationmark.triangle",
                    title: "Le mode découverte",
                    subtitle: "Vous utilisez actuellement votre application en mode découverte !",
                    message: "Vous ne pouvez pas créer de profils et aucune donnée ne sera enregistrée.",
                    callToActionLabel: "Se connecter ou Créer un compte")
            // Blue Information tiles
            case .curriculums:
                return TileContent(
                    image: "graduationcap",
                    title: "Les parcours",
                    subtitle: "Les parcours sont des compilations d'activités dont la difficulté est évolutive.",
                    message:
                    "Les parcours ont pour objectif d'atteindre des compétences précises. Ils ont été pensé avec des professionnels du médico-social. \nVous pouvez réaliser les activités dans l'ordre ou sauter des niveaux."
                )
            case .activities:
                return TileContent(
                    image: "dice",
                    title: "Les activités",
                    subtitle: "Les activités vous permettent de travailler des compétences variées !",
                    message:
                    "Vous trouverez au sein de votre application diverses activités variées. Elles peuvent intéresser les différents métiers du médico-social afin de faire progresser les utilisateurs."
                )
            case .commands:
                return TileContent(
                    image: "gamecontroller",
                    title: "Les commandes",
                    subtitle:
                    "Les commandes vous permettent de créer des activités en utilisant Leka comme médiateur !",
                    message:
                    "Vous pouvez télécommander Leka, le faire tourner, lancer un renforçateur ou encore allumer ses leds dans la couleur souhaitée ! \nL'objectif des commandes est de vous permettre de créer votre propre activité avec l'utilisateur et d'entrer en interaction avec lui."
                )
            // New company signup path
            case .signupBravo:
                return TileContent(
                    image: DesignKitAsset.Images.welcome.name,
                    title: "Félicitations ! 🎉 \nVous venez de créer votre compte Leka !",
                    message: "Nous allons maintenant découvrir l'application \nensemble. Vous êtes prêt ?",
                    callToActionLabel: "👉 C'est parti !")
            case .signupStep1:
                return TileContent(
                    image: DesignKitAsset.Images.accompagnantPicto.name,
                    title: "ÉTAPE 1 :",
                    message: "Nous allons créer votre profil accompagnant.",
                    callToActionLabel: "Créer")
            case .signupStep2:
                return TileContent(
                    image: DesignKitAsset.Images.user.name,
                    title: "ÉTAPE 2 :",
                    message:
                    "Nous allons maintenant créer votre premier \nprofil utilisateur (le profil d'une personne que \nvous accompagnez).",
                    callToActionLabel: "Créer")
            case .signupFinalStep:
                return TileContent(
                    title: "🎉 Encore bravo ! 👏",
                    message: "Vous avez réalisé ces 2 étapes avec brio :",
                    callToActionLabel: "Découvrir le contenu !")
        }
    }
}

// swiftlint:enable line_length
