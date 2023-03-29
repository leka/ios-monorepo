//
//  TileViewModel.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 14/12/22.
//

import Foundation
import SwiftUI

// swiftlint:disable line_length

struct TileContent {
	var image: String?
	var title: String?
	var subtitle: String?
	var message: String?
	var CTALabel: String?
	var pictoCTA: String?
}

enum TileData: Int, CaseIterable, Hashable {
	// swiftlint:disable identifier_name
	case discovery, curriculums, activities, commands, stories, teacher, user, signup_step1, signup_step1_ble,
		signup_step1_Final, signup_step2, signup_step3, signup_finalStep, noBot
	// swiftlint:enable identifier_name

	var id: Self { self }

	var content: TileContent {
		switch self {
			// DiscoveryMode Orange Tile
			case .discovery:
				return TileContent(
					title: "Le mode découverte",
					subtitle: "Vous utilisez actuellement votre application en mode découverte !",
					message: "Vous ne pouvez pas créer de profils et aucune donnée ne sera enregistrée.",
					CTALabel: "Se connecter ou Créer un compte")
			// Blue Information tiles
			case .curriculums:
				return TileContent(
					image: "curriculums",
					title: "Les parcours",
					subtitle: "Les parcours sont des compilations d'activités dont la difficulté est évolutive.",
					message:
						"Les parcours ont pour objectif d'atteindre des compétences précises. Ils ont été pensé avec des professionnels du médico-social. \nVous pouvez réaliser les activités dans l'ordre ou sauter des niveaux."
				)
			case .activities:
				return TileContent(
					image: "activities",
					title: "Les activités",
					subtitle: "Les activités vous permettent de travailler des compétences variées !",
					message:
						"Vous trouverez au sein de votre application diverses activités variées. Elles peuvent intéresser les différents métiers du médico-social afin de faire progresser les utilisateurs."
				)
			case .commands:
				return TileContent(
					image: "commands",
					title: "Les commandes",
					subtitle:
						"Les commandes vous permettent de créer des activités en utilisant Leka comme médiateur !",
					message:
						"Vous pouvez télécommander Leka, le faire tourner, lancer un renforçateur ou encore allumer ses leds dans la couleur souhaitée ! \nL'objectif des commandes est de vous permettre de créer votre propre activité avec l'utilisateur et d'entrer en interaction avec lui."
				)
			case .stories:
				return TileContent(
					image: "stories",
					title: "Les histoires",
					subtitle: "Les histoires sont interactives !",
					message:
						"Vous allez pouvoir lire les aventures de Leka durant vos séances tout en intégrant des activités à réaliser au cours de l'histoire !"
				)
			case .teacher:
				return TileContent(
					image: "accompanying",
					title: "Le suivi",
					subtitle: "Le suivi permet de garder en mémoire l'utilisation de Leka avec chaque profil.",
					message:
						"Le suivi se présente sous la forme d'un historique. Vous y trouverez l'ensemble des activités réalisées de la plus récente à la plus ancienne."
				)
			case .user:
				return TileContent(
					image: "user",
					title: "Le suivi",
					subtitle: "Le suivi permet de garder en mémoire l'utilisation de Leka avec chaque profil.",
					message:
						"Le suivi se présente sous la forme d'un historique. Vous y trouverez l'ensemble des activités réalisées de la plus récente à la plus ancienne."
				)
			// New company signup path
			case .signup_step1:
				return TileContent(
					image: "welcome",
					title: "Félicitations ! 🎉 \nVous venez de créer votre compte Leka !",
					message: "Nous allons maintenant découvrir l'application \nensemble. Vous êtes prêt ?",
					CTALabel: "👉 C'est parti !")
			case .signup_step1_ble:
				return TileContent(
					image: "bluetooth_off",
					title: "ÉTAPE 1 :",
					message:
						"Pour commencer nous allons connecter votre \nLeka en Bluetooth Low Energy (BLE) à votre \niPad et à l'application.",
					CTALabel: "Lancer la connexion",
					pictoCTA: "bluetooth_picto")
			case .signup_step1_Final:
				return TileContent(
					image: "bluetooth_on",
					title: "ÉTAPE 1 :",
					message: "Bravo ! L'application, votre iPad et votre Leka \nsont maintenant connectés ! \n🤝",
					CTALabel: "Continuer")
			case .signup_step2:
				return TileContent(
					image: "accompagnant_picto",
					title: "ÉTAPE 2 :",
					message: "Nous allons maintenant créer votre profil accompagnant.",
					CTALabel: "Créer")
			case .signup_step3:
				return TileContent(
					image: "user",
					title: "ÉTAPE 3 :",
					message:
						"Nous allons maintenant créer votre premier \nprofil utilisateur (le profil d'une personne que \nvous accompagnez).",
					CTALabel: "Créer")
			case .signup_finalStep:
				return TileContent(
					title: "🎉 Encore bravo ! 👏",
					message: "Vous avez réalisé ces 3 étapes avec brio :",
					CTALabel: "Découvrir le contenu !")
			// BotConnect View tile
			case .noBot:
				return TileContent(
					image: "no_bot_found",
					message: "Aucun robot n'a été trouvé. \nSouhaitez-vous passer cette étape ?",
					CTALabel: "👉 Passer")
		}
	}
}

// swiftlint:enable line_length
