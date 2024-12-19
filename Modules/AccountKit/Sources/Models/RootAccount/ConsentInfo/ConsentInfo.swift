// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ConsentInfo: Codable {
    // MARK: Public

    public var policyVersion: String
    public var acceptedAt: Date

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case policyVersion = "policy_version"
        case acceptedAt = "accepted_at"
    }
}
