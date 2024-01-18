// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - UserTypeDeprecated

enum UserTypeDeprecated: Int, CaseIterable {
    case user
    case teacher
}

// MARK: - CompanyDeprecated

struct CompanyDeprecated: Identifiable {
    var id = UUID()
    var mail: String
    var password: String
    var teachers: [TeacherDeprecated] = []
    var users: [UserDeprecated] = []
}

// MARK: - ProfileDeprecated

// Profiles types base-protocol
protocol ProfileDeprecated: Identifiable, Hashable {
    var id: UUID { get }
    var type: UserTypeDeprecated { get }
    var name: String { get set }
    var avatar: String { get set }
}

// MARK: - TeacherDeprecated

struct TeacherDeprecated: ProfileDeprecated {
    // conform
    let id = UUID()
    let type = UserTypeDeprecated.teacher
    var name: String
    var avatar: String

    // specific
    var jobs: [String]
}

// MARK: - UserDeprecated

struct UserDeprecated: ProfileDeprecated {
    // conform
    let id = UUID()
    let type = UserTypeDeprecated.user
    var name: String
    var avatar: String

    // specific
    var reinforcer: Int
}

// MARK: - ProfessionsDeprecated

enum ProfessionsDeprecated: String, Identifiable, CaseIterable {
    // swiftlint:disable identifier_name
    case educSpe
    case eje
    case monit
    case monitAt
    case teach
    case ASC
    case psychoMot
    case ergo
    case ortho
    case kine
    case pedopsy
    case med
    case psy
    case infir
    case soign
    case AESH
    case AES
    case AVDH
    case auxVieScol
    case pueri
    case auxPueri
    case ludo

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
