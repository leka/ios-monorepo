// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

public struct Library: DatabaseDocument, Hashable {
    // MARK: Public

    @ServerTimestamp public var createdAt: Date?
    @ServerTimestamp public var lastEditedAt: Date?

    public var id: String?
    public var rootOwnerUid: String
    public var activities: [SavedActivity]
    public var curriculums: [SavedCurriculum]
    public var stories: [SavedStory]

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case rootOwnerUid = "root_owner_uid"
        case activities
        case curriculums
        case stories
        case createdAt = "created_at"
        case lastEditedAt = "last_edited_at"
    }
}