// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

struct Caregiver: AccountDocument {
    enum CodingKeys: String, CodingKey {
        case id
        case rootOwnerUid = "root_owner_uid"
        case createdAt = "created_at"
        case lastEditedAt = "last_edited_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case avatar
        case professions
        case colorScheme = "color_scheme"
        case accentColor = "accent_color"
    }

    @DocumentID var id: String?
    var rootOwnerUid: String
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var lastEditedAt: Date?
    var firstName: String
    var lastName: String
    var email: String
    var avatar: String
    var professions: [String]
    var colorScheme: Bool
    var accentColor: Int
}
