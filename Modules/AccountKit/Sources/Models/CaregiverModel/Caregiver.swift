// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import FirebaseFirestore
import SwiftUI

// MARK: - Caregiver

public struct Caregiver: AccountDocument {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rootOwnerUid = try container.decode(String.self, forKey: .rootOwnerUid)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.professions = try container.decode([String].self, forKey: .professions)
        self.colorScheme = try container.decode(ColorScheme.self, forKey: .colorScheme)
        self.colorTheme = try container.decode(ColorTheme.self, forKey: .colorTheme)
    }

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
    public var colorScheme: ColorScheme
    public var colorTheme: ColorTheme

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.rootOwnerUid, forKey: .rootOwnerUid)
        try container.encode(self.createdAt, forKey: .createdAt)
        try container.encode(self.lastEditedAt, forKey: .lastEditedAt)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.avatar, forKey: .avatar)
        try container.encode(self.professions, forKey: .professions)
        try container.encode(self.colorScheme, forKey: .colorScheme)
        try container.encode(self.colorTheme, forKey: .colorTheme)
    }

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
        case colorTheme = "color_theme"
    }
}
