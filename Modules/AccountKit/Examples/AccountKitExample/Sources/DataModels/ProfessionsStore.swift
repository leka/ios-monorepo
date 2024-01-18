// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

enum Professions: String, Identifiable, CaseIterable {
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
    // swiftlint:enable identifier_name

    // MARK: Internal

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
