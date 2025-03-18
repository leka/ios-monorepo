// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension SavedStory: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.caregiverID = try container.decodeIfPresent(String.self, forKey: .caregiverID) ?? ""
        self.addedAt = try container.decode(Date.self, forKey: .addedAt)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encode(self.caregiverID, forKey: .caregiverID)
        try container.encode(self.addedAt, forKey: .addedAt)
        try container.encode(self.isFavorite, forKey: .isFavorite)
    }
}
