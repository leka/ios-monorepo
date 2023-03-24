//
//  DiscoveryCompany.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 17/3/23.
//

import SwiftUI

class DiscoveryCompany {
	let discoveryCompany = Company(mail: "discovery@leka.io", password: "Password1234", teachers: discoveryTeachers, users: discoveryUsers)

	static var discoveryTeachers: [Teacher] =
	[
		Teacher(name: "Aurore", avatar: "avatars_leka_cook", jobs: ["Psychomotricien(ne)"]),
		Teacher(name: "Jean-Louis", avatar: "accompanying_blue", jobs: ["Psychomotricien(ne)"]),
		Teacher(name: "Pauline", avatar: "avatars_leka_explorer", jobs: ["Ergothérapeute"]),
		Teacher(name: "Jean-Pierre", avatar: "avatars_boy-3c", jobs: ["Pédopsychiatre"]),
		Teacher(name: "Anne", avatar: "avatars_pictograms-foods-fruits-pineapple_orange-00F9", jobs: ["Accompagnant(e) des élèves en situation de handicap"]),
	]

	static var discoveryUsers: [User] =
	[
		User(name: "Alice", avatar: "avatars_girl-1a", reinforcer: 3),
		User(name: "Olivia", avatar: "avatars_leka_sunglasses_blue", reinforcer: 5),
		User(name: "Alexandre", avatar: "avatars_pictograms-animals-forest-hedgehog_brown-0062", reinforcer: 1),
		User(name: "Érica", avatar: "avatars_leka_moon", reinforcer: 4),
		User(name: "Elessa", avatar: "avatars_pictograms-animals-farm-bird_yellow-0071", reinforcer: 1),
		User(name: "Lucas", avatar: "avatars_boy-1d-144", reinforcer: 2),
		User(name: "Sébastien", avatar: "avatars_pictograms-animals-forest-squirrel_orange-005C", reinforcer: 1),
		User(name: "Maximilien", avatar: "avatars_pictograms-foods-fruits-cherry_red-00FF", reinforcer: 4),
		User(name: "Luc", avatar: "avatars_pictograms-animals-forest-fox_orange-0064", reinforcer: 1),
		User(name: "Élisabeth", avatar: "avatars_sun", reinforcer: 5),
		User(name: "Ariane", avatar: "avatars_pictograms-animals-savanna-giraffe_yellow-0081", reinforcer: 1),
		User(name: "Stéphane", avatar: "avatars_boy-4c", reinforcer: 3),
		User(name: "Lila", avatar: "avatars_pictograms-foods-vegetables-carrot_orange-00E6", reinforcer: 2),
		User(name: "Pierre", avatar: "avatars_pictograms-animals-savanna-lion_brown-0082", reinforcer: 1),
		User(name: "Baptiste", avatar: "avatars_leka-boy-2d", reinforcer: 5),
		User(name: "Éloïse", avatar: "avatars_leka-girl-2d", reinforcer: 4),
		User(name: "Clément", avatar: "avatars_leka_moon", reinforcer: 2),
		User(name: "Simon", avatar: "avatars_leka_marine", reinforcer: 3),
	]
}
