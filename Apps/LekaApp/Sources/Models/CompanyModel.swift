//
//  CompanyModels.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 11/1/23.
//

import SwiftUI

enum UserType: Int, CaseIterable {
    case user, teacher
}

// protocol Company_POP {
//	var id: UUID { get }
//	var mail: String { get set }
//	var password: String { get set }
//	var teachers: [any Profile] { get set }
//	var users: [any Profile] { get set }

//	func disconnect()
//	func sortProfiles(for collection: inout [any Profile])
//	func getNameAndAvatarFor(id: UUID, into: [any Profile]) -> [String]
//	func getAllAvatarsOf(_ collection: [any Profile]) -> [[UUID : String]]
//	func getAllProfileIDsFor(_ collection: [any Profile]) -> [UUID]
// }

struct Company: Identifiable {
    var id = UUID()
    var mail: String
    var password: String
    var teachers: [Teacher] = []
    var users: [User] = []
}

// Profiles types base-protocol
protocol Profile: Identifiable, Hashable {
	var id: UUID { get }
	var type: UserType { get }
	var name: String { get set }
	var avatar: String { get set }
}

struct Teacher: Profile {
	// conform
    let id = UUID()
	let type = UserType.teacher
    var name: String
	var avatar: String

	// specific
    var jobs: [String]
}

struct User: Profile {
	// conform
    let id = UUID()
	let type = UserType.user
    var name: String
    var avatar: String

	// specific
    var reinforcer: Int
}

enum Professions: String, Identifiable, CaseIterable {
    case educSpe, eje, monit, monitAt, teach, ASC, psychoMot, ergo, ortho, kine, pedopsy, med, psy, infir, soign, AESH, AES, AVDH, auxVieScol, pueri, auxPueri, ludo

    var id: Self { self }

    var name: String {
        switch self {
            case .educSpe: return "Éducateur(trice) spécialisé(e)"
            case .eje: return "Éducateur(trice) de jeunes enfants"
            case .monit: return "Moniteur(trice) éducateur(trice)"
            case .monitAt: return "Moniteur(trice) d'atelier"
            case .teach: return "Enseignant(e)"
            case .ASC: return "Animateur(trice) socio-culturel(le)"
            case .psychoMot: return "Psychomotricien(ne)"
            case .ergo: return "Ergothérapeute"
            case .ortho: return "Orthophoniste"
            case .kine: return "Kinésithérapeute"
            case .pedopsy: return "Pédopsychiatre"
            case .med: return "Médecin"
            case .psy: return "Psychologue"
            case .infir: return "Infirmier(ière)"
            case .soign: return "Soignant(e)"
            case .AESH: return "Accompagnant(e) des élèves en situation de handicap"
            case .AES: return "Accompagnant(e) éducatif et social"
            case .AVDH: return "Assistant(e) de vie dépendance et handicap"
            case .auxVieScol: return "Auxiliaire de vie sociale"
            case .pueri: return "Puériculteur(trice)"
            case .auxPueri: return "Auxiliaire de puériculture"
            case .ludo: return "Ludothécaire"
        }
    }
}
