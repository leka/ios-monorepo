// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension ExerciseCompletionData: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startTimestamp = try container.decodeIfPresent(Date.self, forKey: .startTimestamp)
        endTimestamp = try container.decodeIfPresent(Date.self, forKey: .endTimestamp)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(startTimestamp, forKey: .startTimestamp)
        try container.encodeIfPresent(endTimestamp, forKey: .endTimestamp)
    }

    enum CodingKeys: String, CodingKey {
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
    }
}
