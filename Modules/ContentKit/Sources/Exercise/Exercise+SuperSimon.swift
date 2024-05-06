// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable nesting

public enum SuperSimon {
    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.level = try container.decode(Level.self, forKey: .level)
        }

        // MARK: Public

        public let level: Level

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case level
        }
    }

    // MARK: - Level

    public enum Level: String, Equatable, Codable {
        case easy
        case medium
        case hard
    }
}

// swiftlint:enable nesting
