// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UtilsKit

extension CaregiverManager {
    func diff(from oldCaregiver: Caregiver) -> [String: Any] {
        guard let currentCaregiver = self.currentCaregiver.value else {
            log.warning("Current caregiver is nil. Unable to calculate differences.")
            return [:]
        }

        var changes: [String: Any] = [:]

        if currentCaregiver.firstName != oldCaregiver.firstName {
            changes["lk_caregiver_edited_first_name"] = currentCaregiver.firstName
        }
        if currentCaregiver.lastName != oldCaregiver.lastName {
            changes["lk_caregiver_edited_last_name"] = currentCaregiver.lastName
        }
        if currentCaregiver.birthdate != oldCaregiver.birthdate {
            changes["lk_caregiver_edited_birthdate"] = currentCaregiver.birthdate?.iso8601String() ?? NSNull()
        }
        if currentCaregiver.email != oldCaregiver.email {
            changes["lk_caregiver_edited_email"] = currentCaregiver.email
        }
        if currentCaregiver.avatar != oldCaregiver.avatar {
            changes["lk_caregiver_edited_avatar"] = currentCaregiver.avatar
        }
        if currentCaregiver.professions != oldCaregiver.professions {
            changes["lk_caregiver_edited_professions"] = currentCaregiver.professions.joined(separator: ",")
        }
        if currentCaregiver.colorScheme != oldCaregiver.colorScheme {
            changes["lk_caregiver_edited_color_scheme"] = currentCaregiver.colorScheme.rawValue
        }
        if currentCaregiver.colorTheme != oldCaregiver.colorTheme {
            changes["lk_caregiver_edited_color_theme"] = currentCaregiver.colorTheme.rawValue
        }

        return changes
    }
}
