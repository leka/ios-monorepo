// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

extension SavedCurriculum: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.rootOwnerUid = try container.decode(String.self, forKey: .rootOwnerUid)
        self.caregiverID = try container.decodeIfPresent(String.self, forKey: .caregiverID) ?? ""
        self.createdAt = try container.decodeIfPresent(Timestamp.self, forKey: .createdAt)?.dateValue()
        self.lastEditedAt = try container.decodeIfPresent(Timestamp.self, forKey: .lastEditedAt)?.dateValue()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encode(self.rootOwnerUid, forKey: .rootOwnerUid)
        try container.encode(self.caregiverID, forKey: .caregiverID)
        try container.encodeIfPresent(self.createdAt.map { Timestamp(date: $0) }, forKey: .createdAt)
        try container.encodeIfPresent(self.lastEditedAt.map { Timestamp(date: $0) }, forKey: .lastEditedAt)
    }
}
