// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
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
protocol Profile: Identifiable {
    var id: String { get }
    var name: String { get set }
    var avatar: String { get set }
}

// MARK: - Caregiver

struct Caregiver: Profile {
    // MARK: Lifecycle

    init(name: String = "",
         avatar: String = "",
         professions: [Profession] = [],
         colorScheme: ColorScheme = .light,
         accentColor: Color = DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    {
        self.name = name
        self.avatar = avatar
        self.professions = professions
        self.preferredColorScheme = colorScheme
        self.preferredAccentColor = accentColor
    }

    // MARK: Internal

    let id = UUID().uuidString
    var name: String
    var avatar: String
    var professions: [Profession]
    var preferredColorScheme: ColorScheme
    var preferredAccentColor: Color
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
