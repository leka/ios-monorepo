// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension SavedActivity: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.caregiverID = try container.decodeIfPresent(String.self, forKey: .caregiverID) ?? ""

        // Decode the date string back to a Date object
        let dateString = try container.decode(String.self, forKey: .addedAt)
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .addedAt,
                                                   in: container,
                                                   debugDescription: "Date string does not match expected ISO8601 format")
        }
        self.addedAt = date
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.caregiverID, forKey: .caregiverID)

        // Convert Date to an ISO8601 formatted string before encoding
        let dateFormatter = ISO8601DateFormatter()
        let dateString = dateFormatter.string(from: self.addedAt)
        try container.encode(dateString, forKey: .addedAt)
    }
}
