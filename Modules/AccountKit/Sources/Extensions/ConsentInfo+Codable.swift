// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension ConsentInfo: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.policyVersion = try container.decode(String.self, forKey: .policyVersion)
        self.acceptedAt = try container.decode(Date.self, forKey: .acceptedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.policyVersion, forKey: .policyVersion)
        try container.encode(self.acceptedAt, forKey: .acceptedAt)
    }
}
