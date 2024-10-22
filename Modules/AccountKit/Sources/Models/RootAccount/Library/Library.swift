// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

// MARK: - SavedActivity

public struct Library: DatabaseDocument, Hashable {
    // MARK: Public

    @ServerTimestamp public var createdAt: Date?
    @ServerTimestamp public var lastEditedAt: Date?

    public var id: String?
    public var rootOwnerUid: String
    public var savedActivities: [SavedActivity]
    public var savedCurriculums: [SavedCurriculum]
    public var savedStories: [SavedStory]
    public var savedGamepads: [SavedGamepad]

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case rootOwnerUid = "root_owner_uid"
        case savedActivities = "saved_activities"
        case savedCurriculums = "saved_curriculums"
        case savedStories = "saved_stories"
        case savedGamepads = "saved_gamepads"
        case createdAt = "created_at"
        case lastEditedAt = "last_edited_at"
    }
}
