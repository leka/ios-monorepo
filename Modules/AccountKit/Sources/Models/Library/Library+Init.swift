// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension Library {
    init(
        id: String? = nil,
        rootOwnerUid: String = "",
        activities: [SavedActivity] = [],
        curriculums: [SavedCurriculum] = [],
        stories: [SavedStory] = [],
        createdAt _: Date? = nil,
        lastEditedAt _: Date? = nil
    ) {
        self.id = id
        self.rootOwnerUid = rootOwnerUid
        self.activities = activities
        self.curriculums = curriculums
        self.stories = stories
    }
}
