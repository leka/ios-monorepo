// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - Exercise.Action

// swiftlint:disable nesting

public extension Exercise {
    enum Action: Codable {
        case ipad(type: ActionType)
        case robot(type: ActionType)

        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            let valueContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .value)
            switch type {
                case "ipad":
                    let valueType = try valueContainer.decode(ValueType.self, forKey: .type)
                    switch valueType {
                        case .color:
                            let color = try valueContainer.decode(String.self, forKey: .value)
                            self = .ipad(type: .color(color))
                        case .image:
                            let image = try valueContainer.decode(String.self, forKey: .value)
                            self = .ipad(type: .image(image))
                        case .sfsymbol:
                            let symbol = try valueContainer.decode(String.self, forKey: .value)
                            self = .ipad(type: .sfsymbol(symbol))
                        case .audio:
                            let audio = try valueContainer.decode(String.self, forKey: .value)
                            self = .ipad(type: .audio(audio))
                        case .speech:
                            let localizedSpeech = try valueContainer.decode([LocalizedSpeech].self, forKey: .value)

                            let availableLocales = localizedSpeech.map(\.locale)
                            let currentLocale = availableLocales.first(where: {
                                $0.language.languageCode == LocalizationKit.l10n.language
                            }) ?? Locale(identifier: "en_US")

                            let speech = localizedSpeech.first(where: { $0.locale == currentLocale })?.utterance
                            self = .ipad(type: .speech(speech!))
                    }
                case "robot":
                    let valueType = try valueContainer.decode(ValueType.self, forKey: .type)
                    switch valueType {
                        case .image:
                            let image = try valueContainer.decode(String.self, forKey: .value)
                            self = .robot(type: .image(image))
                        case .color:
                            let color = try valueContainer.decode(String.self, forKey: .value)
                            self = .robot(type: .color(color))
                        default:
                            throw DecodingError.dataCorruptedError(
                                forKey: .type,
                                in: valueContainer,
                                debugDescription: "Unexpected type for RobotMedia"
                            )
                    }
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

        public enum ActionType: Codable {
            case color(String)
            case image(String)
            case emoji(String)
            case sfsymbol(String)
            case audio(String)
            case speech(String)
        }

        public enum ValueType: String, Codable {
            case color
            case image
            case sfsymbol
            case audio
            case speech
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {
                case let .ipad(ipadAction):
                    try container.encode("ipad", forKey: .type)
                    var valueContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .value)
                    switch ipadAction {
                        case let .color(value):
                            try valueContainer.encode("color", forKey: .type)
                            try valueContainer.encode(value, forKey: .value)
                        case let .image(name):
                            try valueContainer.encode("image", forKey: .type)
                            try valueContainer.encode(name, forKey: .value)
                        case let .emoji(name):
                            try valueContainer.encode("emoji", forKey: .type)
                            try valueContainer.encode(name, forKey: .value)
                        case let .sfsymbol(name):
                            try valueContainer.encode("sfsymbol", forKey: .type)
                            try valueContainer.encode(name, forKey: .value)
                        case let .audio(name):
                            try valueContainer.encode("audio", forKey: .type)
                            try valueContainer.encode(name, forKey: .value)
                        case let .speech(value):
                            try valueContainer.encode("speech", forKey: .type)
                            try valueContainer.encode(value, forKey: .value)
                    }
                case let .robot(robotAction):
                    try container.encode("robot", forKey: .type)
                    var valueContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .value)
                    switch robotAction {
                        case let .image(name):
                            try valueContainer.encode("image", forKey: .type)
                            try valueContainer.encode(name, forKey: .value)
                        case let .color(value):
                            try valueContainer.encode("color", forKey: .type)
                            try valueContainer.encode(value, forKey: .value)
                        case .audio:
                            log.error("Action Audio not available for robot ")
                            fatalError("💥 Action Audio not available for robot")
                        case .speech:
                            log.error("Action Speech not available for robot ")
                            fatalError("💥 Action Speech not available for robot")
                        case .emoji:
                            log.error("Action Emoji not available for robot ")
                            fatalError("💥 Action Emoji not available for robot")
                        case .sfsymbol:
                            log.error("Action SFSymbol not available for robot ")
                            fatalError("💥 Action SFSymbol not available for robot")
                    }
            }
        }

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case type
            case value
        }
    }
}

// MARK: - Exercise.LocalizedSpeech

public extension Exercise {
    struct LocalizedSpeech: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.utterance = try container.decode(String.self, forKey: .utterance)
        }

        // MARK: Internal

        let locale: Locale
        let utterance: String
    }
}

// swiftlint:enable nesting
