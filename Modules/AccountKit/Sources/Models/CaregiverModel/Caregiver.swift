// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import FirebaseFirestore
import SwiftUI

// MARK: - Caregiver

public struct Caregiver: AccountDocument, Hashable {
    // MARK: Public

    @ServerTimestamp public var createdAt: Date?
    @ServerTimestamp public var lastEditedAt: Date?

    public var id: String?
    public var rootOwnerUid: String
    public var firstName: String
    public var lastName: String
    public var birthdate: Date?
    public var email: String
    public var avatar: String
    public var professions: [String]
    public var colorScheme: ColorScheme
    public var colorTheme: ColorTheme
    public var isAdmin: Bool? = false

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case rootOwnerUid = "root_owner_uid"
        case createdAt = "created_at"
        case lastEditedAt = "last_edited_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case birthdate
        case email
        case avatar
        case professions
        case colorScheme = "color_scheme"
        case colorTheme = "color_theme"
        case isAdmin = "is_admin"
    }
}
