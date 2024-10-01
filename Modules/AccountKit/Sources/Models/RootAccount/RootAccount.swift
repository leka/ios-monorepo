// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

public struct RootAccount: AccountDocument {
    // MARK: Public

    public var id: String?
    @ServerTimestamp public var createdAt: Date?
    @ServerTimestamp public var lastEditedAt: Date?
    public var rootOwnerUid: String
    public var savedActivities: [SavedActivity]

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case rootOwnerUid = "root_owner_uid"
        case savedActivities = "saved_activities"
        case createdAt = "created_at"
        case lastEditedAt = "last_edited_at"
    }
}
