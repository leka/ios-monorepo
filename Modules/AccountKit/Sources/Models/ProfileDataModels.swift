// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

public struct Caregiver: AccountDocument {
    // MARK: Public

    @DocumentID public var id: String?
    @ServerTimestamp public var createdAt: Date?
    @ServerTimestamp public var lastEditedAt: Date?
    public var rootOwnerUid: String
    public var firstName: String
    public var lastName: String
    public var email: String
    public var avatar: String
    public var professions: [String]
    public var colorScheme: Bool
    public var accentColor: Int

    // MARK: Internal

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
}
