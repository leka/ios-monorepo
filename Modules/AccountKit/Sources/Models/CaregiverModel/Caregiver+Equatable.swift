// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension Caregiver: Equatable {
    public static func == (lhs: Caregiver, rhs: Caregiver) -> Bool {
        lhs.id == rhs.id &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.birthdate == rhs.birthdate &&
            lhs.email == rhs.email &&
            lhs.avatar == rhs.avatar &&
            lhs.professions == rhs.professions &&
            lhs.colorScheme == rhs.colorScheme &&
            lhs.colorTheme == rhs.colorTheme
    }
}
