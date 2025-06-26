// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension SavedCurriculum: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.caregiverID = try container.decodeIfPresent(String.self, forKey: .caregiverID) ?? ""
        self.addedAt = try container.decode(Date.self, forKey: .addedAt)
        self.favoritedBy = try container.decodeIfPresent([String: Date].self, forKey: .favoritedBy) ?? [:]
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.caregiverID, forKey: .caregiverID)
        try container.encode(self.addedAt, forKey: .addedAt)
        try container.encode(self.favoritedBy, forKey: .favoritedBy)
    }
}
