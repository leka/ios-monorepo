// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - Page.Action

// swiftlint:disable nesting cyclomatic_complexity

public extension Page {
    enum Action: Decodable {
        case ipad(type: TabletActionType)
        case robot(type: RobotActionType)

        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(ActionType.self, forKey: .type)
            let valueContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .value)
            switch type {
                case .ipad:
                    let valueType = try valueContainer.decode(TabletValueType.self, forKey: .type)
                    switch valueType {
                        case .activity:
                            guard let activityID = try valueContainer.decode(String.self, forKey: .value)
                                .split(separator: "-")
                                .last?
                                .trimmingCharacters(in: .whitespaces)
                            else {
                                throw DecodingError.dataCorrupted(
                                    DecodingError.Context(
                                        codingPath: valueContainer.codingPath,
                                        debugDescription: "Activity ID unsupported"
                                    )
                                )
                            }

                            self = .ipad(type: .activity(activityID))
                        default:
                            // TODO: (@HPezz) Implement Audio & Speech actions
                            throw DecodingError.dataCorrupted(
                                DecodingError.Context(
                                    codingPath: valueContainer.codingPath,
                                    debugDescription: "Value type \(valueType) is not yet supported"
                                )
                            )
                    }
                case .robot:
                    let valueType = try valueContainer.decode(RobotValueType.self, forKey: .type)
                    switch valueType {
                        case .reinforcer:
                            let value = try valueContainer.decode(UInt8.self, forKey: .value)
                            self = .robot(type: .reinforcer(value))
                        case .random:
                            let type = try valueContainer.decode(RandomActionType.self, forKey: .value)
                            self = .robot(type: .random(type))
                        case .motion:
                            let type = try valueContainer.decode(MotionType.self, forKey: .value)
                            self = .robot(type: .motion(type))
                        case .image:
                            let image = try valueContainer.decode(String.self, forKey: .value)
                            self = .robot(type: .image(image))
                        case .color:
                            let color = try valueContainer.decode(String.self, forKey: .value)
                            self = .robot(type: .color(color))
                        case .flash:
                            let repetition = try valueContainer.decode(Int.self, forKey: .value)
                            self = .robot(type: .flash(repetition))
                        case .spots:
                            let numberOfSpots = try valueContainer.decode(Int.self, forKey: .value)
                            self = .robot(type: .spots(numberOfSpots))
                    }
            }
        }

        // MARK: Public

        public enum ActionType: String, Codable {
            case ipad
            case robot
        }

        public enum TabletActionType: Codable {
            case activity(String)
            case speech(String)
            case audio(String)
        }

        public enum TabletValueType: String, Codable {
            case activity
            case speech
            case audio
        }

        public enum RobotActionType: Codable {
            case random(RandomActionType)
            case motion(MotionType)
            case reinforcer(UInt8)
            case color(String)
            case image(String)
            case flash(Int)
            case spots(Int)
        }

        public enum RobotValueType: String, Codable {
            case reinforcer
            case random
            case motion
            case color
            case image
            case flash
            case spots
        }

        public enum RandomActionType: String, Codable {
            case reinforcer
            case color
            case move
        }

        public enum MotionType: String, Codable {
            case bootyShake
            case dance
            case spin
        }

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case type
            case value
        }
    }
}

// swiftlint:enable nesting cyclomatic_complexity
