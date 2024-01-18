// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - Company

struct Company: Identifiable {
    var id = UUID().uuidString
    var email: String
    var password: String
    var caregivers: [Caregiver] = []
    var carereceivers: [Carereceiver] = []
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
    let id = UUID().uuidString
    var name: String
    var avatar: String
    var professions: [Profession]
}

// MARK: - Carereceiver

struct Carereceiver: Profile {
    let id = UUID().uuidString
    var name: String
    var avatar: String
    var reinforcer: Int
}

// MARK: - Caregiver.Profession

extension Caregiver {
    enum Profession {
        case motorTherapist
        case occupationalTherapist
        case speechTherapist
    }
}
