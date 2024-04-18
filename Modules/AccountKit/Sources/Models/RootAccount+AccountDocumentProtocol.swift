// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

// MARK: - AccountDocument

public protocol AccountDocument: Codable, Identifiable {
    var id: String? { get set }
    var rootOwnerUid: String { get set }
    var createdAt: Date? { get set }
    var lastEditedAt: Date? { get set }
}

// MARK: - RootAccount

public struct RootAccount: AccountDocument {
    // MARK: Public

    public var id: String?
    @ServerTimestamp public var createdAt: Date?
    @ServerTimestamp public var lastEditedAt: Date?
    public var rootOwnerUid: String

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case rootOwnerUid = "root_owner_uid"
        case createdAt = "created_at"
        case lastEditedAt = "last_edited_at"
    }
}
