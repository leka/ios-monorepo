// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - NewExerciseAction

public enum NewExerciseAction: Decodable, Equatable {
    case ipad(type: TabletActionType)
    case robot(type: RobotActionType)

    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ActionType.self, forKey: .type)
        let valueContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .value)
        switch type {
            case .ipad:
                self = try NewExerciseAction.decodeIpadAction(from: valueContainer)
            case .robot:
                self = try NewExerciseAction.decodeRobotAction(from: valueContainer)
        }
    }

    // MARK: Public

    public enum ActionType: String, Decodable {
        case robot
        case ipad
    }

    public enum TabletActionType: Decodable, Equatable {
        case color(String)
        case image(String)
        case emoji(String)
        case sfsymbol(String)
        case audio(String)
        case speech(String)
    }

    public enum RobotActionType: Decodable, Equatable {
        case color(String)
        case image(String)
        case flash(Int)
        case spots(Int)
    }

    public enum TabletValueType: String, Decodable {
        case color
        case image
        case sfsymbol
        case audio
        case speech
    }

    public enum RobotValueType: String, Decodable {
        case color
        case image
        case flash
        case spots
    }

    // MARK: Internal

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

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    private static func decodeIpadAction(from container: KeyedDecodingContainer<CodingKeys>) throws -> NewExerciseAction {
        let valueType = try container.decode(TabletValueType.self, forKey: .type)
        switch valueType {
            case .color:
                let color = try container.decode(String.self, forKey: .value)
                return .ipad(type: .color(color))
            case .image:
                let image = try container.decode(String.self, forKey: .value)
                return .ipad(type: .image(image))
            case .sfsymbol:
                let symbol = try container.decode(String.self, forKey: .value)
                return .ipad(type: .sfsymbol(symbol))
            case .audio:
                let audio = try container.decode(String.self, forKey: .value)
                return .ipad(type: .audio(audio))
            case .speech:
                let localizedSpeech = try container.decode([LocalizedSpeech].self, forKey: .value)

                let availableLocales = localizedSpeech.map(\.locale)
                let currentLocale = availableLocales.first(where: {
                    $0.language.languageCode == LocalizationKit.l10n.language
                }) ?? Locale(identifier: "en_US")

                let speech = localizedSpeech.first(where: { $0.locale == currentLocale })?.utterance
                return .ipad(type: .speech(speech!))
        }
    }

    private static func decodeRobotAction(from container: KeyedDecodingContainer<CodingKeys>) throws -> NewExerciseAction {
        let valueType = try container.decode(RobotValueType.self, forKey: .type)
        switch valueType {
            case .image:
                let image = try container.decode(String.self, forKey: .value)
                return .robot(type: .image(image))
            case .color:
                let color = try container.decode(String.self, forKey: .value)
                return .robot(type: .color(color))
            case .flash:
                let repetition = try container.decode(Int.self, forKey: .value)
                return .robot(type: .flash(repetition))
            case .spots:
                let numberOfSpots = try container.decode(Int.self, forKey: .value)
                return .robot(type: .spots(numberOfSpots))
        }
    }
}
