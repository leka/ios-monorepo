// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

// MARK: Interaction

public struct Interaction: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.input = try container.decode(Input.self, forKey: .input)
        self.medium = try container.decode(Medium.self, forKey: .medium)
        self.attention = try container.decodeIfPresent(Attention.self, forKey: .attention)
    }

    // MARK: Public

    public enum Medium: String, Codable {
        case robot
        case tablet
        case tabletRobot = "tablet_robot"
    }

    public enum Input: String, Codable {
        case mixed
        case magicCard = "magic_card"
        case dragAndDrop = "drag_and_drop"
        case touchToSelect = "touch_to_select"
    }

    public enum Attention: String, Codable {
        case look
        case mixed
        case listen
    }

    public let input: Input
    public let medium: Medium
    public let attention: Attention?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case input
        case medium
        case attention
    }
}
