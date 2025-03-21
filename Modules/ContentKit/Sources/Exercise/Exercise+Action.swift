// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - Exercise.Action

// swiftlint:disable nesting cyclomatic_complexity

public extension Exercise {
    enum Action: Codable {
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
                case .robot:
                    let valueType = try valueContainer.decode(RobotValueType.self, forKey: .type)
                    switch valueType {
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
            case robot
            case ipad
        }

        public enum TabletActionType: Codable {
            case color(String)
            case image(String)
            case emoji(String)
            case sfsymbol(String)
            case audio(String)
            case speech(String)
        }

        public enum RobotActionType: Codable {
            case color(String)
            case image(String)
            case flash(Int)
            case spots(Int)
        }

        public enum TabletValueType: String, Codable {
            case color
            case image
            case sfsymbol
            case audio
            case speech
        }

        public enum RobotValueType: String, Codable {
            case color
            case image
            case flash
            case spots
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
                        case let .flash(value):
                            try valueContainer.encode("flash", forKey: .type)
                            try valueContainer.encode(value, forKey: .value)
                        case let .spots(value):
                            try valueContainer.encode("spots", forKey: .type)
                            try valueContainer.encode(value, forKey: .value)
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

// swiftlint:enable nesting cyclomatic_complexity
