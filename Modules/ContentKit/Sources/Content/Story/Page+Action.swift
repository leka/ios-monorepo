// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swiftlint:disable nesting

public extension Page {
    enum Action: Decodable {
        case activity(type: String)
        case robot(type: ActionType)
        case none

        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            switch type {
                case "activity":
                    let activityID = try container.decode(String.self, forKey: .value)
                        .split(separator: "-")
                        .last?
                        .trimmingCharacters(in: .whitespaces)

                    self = .activity(type: activityID!)
                case "robot":
                    let actionRawValue = try container.decodeIfPresent(String.self, forKey: .value)
                    self = .robot(type: ActionType(rawValue: actionRawValue!)!)
                default:
                    throw DecodingError.dataCorruptedError(
                        forKey: .type,
                        in: container,
                        debugDescription:
                        "Cannot decode ExercisePayload. Available keys: \(container.allKeys.map(\.stringValue))"
                    )
            }
        }

        // MARK: Public

        public enum ActionType: String, Codable {
            case bootyShake
            case randomColor
            case randomMove
            case reinforcer
            case yellow
            case spin
            case dance
        }

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case type
            case value
        }
    }
}

// swiftlint:enable nesting
