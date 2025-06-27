// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension Caregiver {
    init(
        id: String = "",
        rootOwnerUid: String = "",
        firstName: String = "",
        lastName: String = "",
        birthdate: Date? = nil,
        email: String = "",
        avatar: String = "",
        professions: [String] = [],
        colorScheme: ColorScheme = .light,
        colorTheme: ColorTheme = .darkBlue,
        isAdmin: Bool = false
    ) {
        self.id = id
        self.rootOwnerUid = rootOwnerUid
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
        self.email = email
        self.avatar = avatar
        self.professions = professions
        self.colorScheme = colorScheme
        self.colorTheme = colorTheme
        self.isAdmin = isAdmin
    }
}
