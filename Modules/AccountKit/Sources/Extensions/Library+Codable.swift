// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension Library: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.savedActivities = try container.decodeIfPresent([SavedActivity].self, forKey: .savedActivities) ?? []
        self.savedCurriculums = try container.decodeIfPresent([SavedCurriculum].self, forKey: .savedCurriculums) ?? []
        self.savedStories = try container.decodeIfPresent([SavedStory].self, forKey: .savedStories) ?? []
        self.savedGamepads = try container.decodeIfPresent([SavedGamepad].self, forKey: .savedGamepads) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.savedActivities, forKey: .savedActivities)
        try container.encode(self.savedCurriculums, forKey: .savedCurriculums)
        try container.encode(self.savedStories, forKey: .savedStories)
        try container.encode(self.savedGamepads, forKey: .savedGamepads)
    }
}
