// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension Library {
    init(
        id: String? = nil,
        rootOwnerUid: String = "",
        savedActivities: [SavedActivity] = [],
        savedCurriculums: [SavedCurriculum] = [],
        savedStories: [SavedStory] = [],
        savedGamepads: [SavedGamepad] = []
    ) {
        self.id = id
        self.rootOwnerUid = rootOwnerUid
        self.savedActivities = savedActivities
        self.savedCurriculums = savedCurriculums
        self.savedStories = savedStories
        self.savedGamepads = savedGamepads
        self.createdAt = nil
        self.lastEditedAt = nil
    }
}
