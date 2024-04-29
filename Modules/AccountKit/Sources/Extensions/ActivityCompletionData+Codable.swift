// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension ActivityCompletionData: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        rootOwnerUid = try container.decode(String.self, forKey: .rootOwnerUid)
        caregiverID = try container.decode(String.self, forKey: .caregiverID)
        carereceiverID = try container.decode(String.self, forKey: .carereceiverID)
        startTimestamp = try container.decodeIfPresent(Date.self, forKey: .startTimestamp)
        endTimestamp = try container.decodeIfPresent(Date.self, forKey: .endTimestamp)
        completionData = try container.decode([[ExerciseCompletionData]].self, forKey: .completionData)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(rootOwnerUid, forKey: .rootOwnerUid)
        try container.encode(caregiverID, forKey: .caregiverID)
        try container.encode(carereceiverID, forKey: .carereceiverID)
        try container.encodeIfPresent(startTimestamp, forKey: .startTimestamp)
        try container.encodeIfPresent(endTimestamp, forKey: .endTimestamp)
        try container.encode(completionData, forKey: .completionData)
    }
}
