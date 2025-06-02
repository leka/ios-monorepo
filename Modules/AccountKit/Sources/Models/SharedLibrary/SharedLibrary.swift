// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

public struct SharedLibrary: DatabaseDocument, Hashable {
    // MARK: Public

    @ServerTimestamp public var createdAt: Date?
    @ServerTimestamp public var lastEditedAt: Date?

    public var id: String?
    public var rootOwnerUid: String

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case rootOwnerUid = "root_owner_uid"
        case createdAt = "created_at"
        case lastEditedAt = "last_edited_at"
    }
}
