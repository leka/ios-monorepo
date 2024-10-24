// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

extension Library: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.rootOwnerUid = try container.decode(String.self, forKey: .rootOwnerUid)
        self.savedActivities = try container.decodeIfPresent([SavedActivity].self, forKey: .savedActivities) ?? []
        self.savedCurriculums = try container.decodeIfPresent([SavedCurriculum].self, forKey: .savedCurriculums) ?? []
        self.savedStories = try container.decodeIfPresent([SavedStory].self, forKey: .savedStories) ?? []
        self.savedGamepads = try container.decodeIfPresent([SavedGamepad].self, forKey: .savedGamepads) ?? []
        self.createdAt = try container.decodeIfPresent(Timestamp.self, forKey: .createdAt)?.dateValue()
        self.lastEditedAt = try container.decodeIfPresent(Timestamp.self, forKey: .lastEditedAt)?.dateValue()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encode(self.rootOwnerUid, forKey: .rootOwnerUid)
        try container.encode(self.savedActivities, forKey: .savedActivities)
        try container.encode(self.savedCurriculums, forKey: .savedCurriculums)
        try container.encode(self.savedStories, forKey: .savedStories)
        try container.encode(self.savedGamepads, forKey: .savedGamepads)
        try container.encodeIfPresent(self.createdAt.map { Timestamp(date: $0) }, forKey: .createdAt)
        try container.encodeIfPresent(self.lastEditedAt.map { Timestamp(date: $0) }, forKey: .lastEditedAt)
    }
}
