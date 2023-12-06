// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - UserType

enum UserType: Int, CaseIterable {
    case user, teacher
}

// MARK: - Company

struct Company: Identifiable {
    var id = UUID()
    var mail: String
    var password: String
    var teachers: [Teacher] = []
    var users: [User] = []
}

// MARK: - Profile

// Profiles types base-protocol
protocol Profile: Identifiable, Hashable {
    var id: UUID { get }
    var type: UserType { get }
    var name: String { get set }
    var avatar: String { get set }
}

// MARK: - Teacher

struct Teacher: Profile {
    // conform
    let id = UUID()
    let type = UserType.teacher
    var name: String
    var avatar: String

    // specific
    var jobs: [String]
}

// MARK: - User

struct User: Profile {
    // conform
    let id = UUID()
    let type = UserType.user
    var name: String
    var avatar: String

    // specific
    var reinforcer: Int
}

// MARK: - Professions

enum Professions: String, Identifiable, CaseIterable {
    // swiftlint:disable identifier_name
    case educSpe, eje, monit, monitAt, teach, ASC, psychoMot,
         ergo, ortho, kine, pedopsy, med, psy, infir, soign,
         AESH, AES, AVDH, auxVieScol, pueri, auxPueri, ludo

    // MARK: Internal

    // swiftlint:enable identifier_name

    var id: Self { self }

    var name: String {
        switch self {
            case .educSpe: "Éducateur(trice) spécialisé(e)"
            case .eje: "Éducateur(trice) de jeunes enfants"
            case .monit: "Moniteur(trice) éducateur(trice)"
            case .monitAt: "Moniteur(trice) d'atelier"
            case .teach: "Enseignant(e)"
            case .ASC: "Animateur(trice) socio-culturel(le)"
            case .psychoMot: "Psychomotricien(ne)"
            case .ergo: "Ergothérapeute"
            case .ortho: "Orthophoniste"
            case .kine: "Kinésithérapeute"
            case .pedopsy: "Pédopsychiatre"
            case .med: "Médecin"
            case .psy: "Psychologue"
            case .infir: "Infirmier(ière)"
            case .soign: "Soignant(e)"
            case .AESH: "Accompagnant(e) des élèves en situation de handicap"
            case .AES: "Accompagnant(e) éducatif et social"
            case .AVDH: "Assistant(e) de vie dépendance et handicap"
            case .auxVieScol: "Auxiliaire de vie sociale"
            case .pueri: "Puériculteur(trice)"
            case .auxPueri: "Auxiliaire de puériculture"
            case .ludo: "Ludothécaire"
        }
    }
}
