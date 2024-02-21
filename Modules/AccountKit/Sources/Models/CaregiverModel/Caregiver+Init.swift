// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension Caregiver {
    init(rootOwnerUid: String = "",
         firstName: String = "",
         lastName: String = "",
         email: String = "",
         avatar: String = "",
         professions: [String] = [],
         colorScheme: ColorScheme = .light,
         colorTheme: ColorTheme = .darkBlue)
    {
        self.rootOwnerUid = rootOwnerUid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.avatar = avatar
        self.professions = professions
        self.colorScheme = colorScheme
        self.colorTheme = colorTheme
    }
}
