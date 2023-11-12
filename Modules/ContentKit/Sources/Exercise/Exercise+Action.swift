// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swiftlint:disable nesting

extension Exercise {

    public enum Action: Codable {

        case ipad(type: IpadMedia)
        case robot(type: RobotMedia)

        public enum IpadMedia: Codable {
            case color(value: String)
            case image(name: String)
            case audio(name: String)
            case speech(content: String)
        }

        public enum RobotMedia: Codable {
            case image(id: String)
            case color(value: String)
        }

        private enum CodingKeys: String, CodingKey {
            case type
            case value
        }

        public enum ValueType: String, Codable {
            case color
            case image
            case audio
            case speech
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {
                case .ipad(let ipadAction):
                    try container.encode("ipad", forKey: .type)
                    var valueContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .value)
                    switch ipadAction {
                        case .color(let value):
                            try valueContainer.encode("color", forKey: .type)
                            try valueContainer.encode(value, forKey: .value)
                        case .image(let name):
                            try valueContainer.encode("image", forKey: .type)
                            try valueContainer.encode(name, forKey: .value)
                        case .audio(let name):
                            try valueContainer.encode("audio", forKey: .type)
                            try valueContainer.encode(name, forKey: .value)
                        case .speech(let value):
                            try valueContainer.encode("speech", forKey: .type)
                            try valueContainer.encode(value, forKey: .value)
                    }
                case .robot(let robotAction):
                    try container.encode("robot", forKey: .type)
                    var valueContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .value)
                    switch robotAction {
                        case .image(let id):
                            try valueContainer.encode("image", forKey: .type)
                            try valueContainer.encode(id, forKey: .value)
                        case .color(let value):
                            try valueContainer.encode("color", forKey: .type)
                            try valueContainer.encode(value, forKey: .value)
                    }
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            let valueContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .value)
            switch type {
                case "ipad":
                    let valueType = try valueContainer.decode(ValueType.self, forKey: .type)
                    switch valueType {
                        case .color:
                            let colorValue = try valueContainer.decode(String.self, forKey: .value)
                            self = .ipad(type: .color(value: colorValue))
                        case .image:
                            let imageName = try valueContainer.decode(String.self, forKey: .value)
                            self = .ipad(type: .image(name: imageName))
                        case .audio:
                            let audioName = try valueContainer.decode(String.self, forKey: .value)
                            self = .ipad(type: .audio(name: audioName))
                        case .speech:
                            let speechValue = try valueContainer.decode(String.self, forKey: .value)
                            self = .ipad(type: .speech(content: speechValue))
                    }
                case "robot":
                    let valueType = try valueContainer.decode(ValueType.self, forKey: .type)
                    switch valueType {
                        case .image:
                            let imageId = try valueContainer.decode(String.self, forKey: .value)
                            self = .robot(type: .image(id: imageId))
                        case .color:
                            let colorValue = try valueContainer.decode(String.self, forKey: .value)
                            self = .robot(type: .color(value: colorValue))
                        default:
                            throw DecodingError.dataCorruptedError(
                                forKey: .type,
                                in: valueContainer,
                                debugDescription: "Unexpected type for RobotMedia")
                    }
                default:
                    throw DecodingError.dataCorruptedError(
                        forKey: .type,
                        in: container,
                        debugDescription:
                            "Cannot decode ExercisePayload. Available keys: \(container.allKeys.map { $0.stringValue })"
                    )
            }
        }

    }

}

// swiftlint:enable nesting
