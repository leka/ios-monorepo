// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - Company

struct Company: Identifiable {
    var id = UUID().uuidString
    var email: String
    var password: String
}

// MARK: - Profile

// Profiles types base-protocol
protocol Profile: Identifiable, Hashable {
    var id: String { get }
    var name: String { get set }
    var avatar: String { get set }
}

// MARK: - Caregiver

struct Caregiver: Profile {
    // MARK: Lifecycle

    init(name: String = "", avatar: String = "", professions: [Profession] = []) {
        self.name = name
        self.avatar = avatar
        self.professions = professions
    }

    // MARK: Internal

    let id = UUID().uuidString
    var name: String
    var avatar: String
    var professions: [Profession]
}

// MARK: - Carereceiver

struct Carereceiver: Profile {
    // MARK: Lifecycle

    init(name: String = "", avatar: String = "", reinforcer: Int = 1) {
        self.name = name
        self.avatar = avatar
        self.reinforcer = reinforcer
    }

    // MARK: Internal

    let id = UUID().uuidString
    var name: String
    var avatar: String
    var reinforcer: Int
}

// MARK: - Caregiver.Profession

extension Caregiver {
    enum Profession: CaseIterable, Equatable, Hashable {
        case motorTherapist
        case occupationalTherapist
        case speechTherapist
        case other(profession: String = "")

        // MARK: Internal

        static var allCases: [Profession] {
            [
                .motorTherapist,
                .occupationalTherapist,
                .speechTherapist,
            ]
        }

        var name: String {
            switch self {
                case .motorTherapist:
                    "Motor Therapist"
                case .occupationalTherapist:
                    "Occupational Therapist"
                case .speechTherapist:
                    "Speech Therapist"
                case let .other(profession):
                    profession
            }
        }
    }
}
