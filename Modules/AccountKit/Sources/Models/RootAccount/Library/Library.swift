// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

// MARK: - SavedActivity

public struct Library: Hashable {
    // MARK: Lifecycle

    public init(
        savedActivities: [SavedActivity] = [],
        savedCurriculums: [SavedCurriculum] = [],
        savedStories: [SavedStory] = [],
        savedGamepads: [SavedGamepad] = []
    ) {
        self.savedActivities = savedActivities
        self.savedCurriculums = savedCurriculums
        self.savedStories = savedStories
        self.savedGamepads = savedGamepads
    }

    // MARK: Public

    public var savedActivities: [SavedActivity]
    public var savedCurriculums: [SavedCurriculum]
    public var savedStories: [SavedStory]
    public var savedGamepads: [SavedGamepad]

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case savedActivities = "saved_activities"
        case savedCurriculums = "saved_curriculums"
        case savedStories = "saved_stories"
        case savedGamepads = "saved_gamepads"
    }
}
