// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

public extension Library {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.rootOwnerUid = try container.decode(String.self, forKey: .rootOwnerUid)
        self.activities = try container.decodeIfPresent([SavedActivity].self, forKey: .activities) ?? []
        self.curriculums = try container.decodeIfPresent([SavedCurriculum].self, forKey: .curriculums) ?? []
        self.stories = try container.decodeIfPresent([SavedStory].self, forKey: .stories) ?? []
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.lastEditedAt = try container.decodeIfPresent(Date.self, forKey: .lastEditedAt)
    }
}
