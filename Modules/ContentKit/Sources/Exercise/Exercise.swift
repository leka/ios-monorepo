// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - Exercise

public struct Exercise: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.interface = try container.decode(Interface.self, forKey: .interface)
        self.gameplay = try container.decodeIfPresent(Gameplay.self, forKey: .gameplay)
        self.action = try container.decodeIfPresent(Action.self, forKey: .action)

        self.localizedInstructions = try? container.decode([LocalizedInstructions].self, forKey: .localizedInstructions)

        if let localizedInstructions = self.localizedInstructions {
            let availableLocales = localizedInstructions.map(\.locale)

            let currentLocale = availableLocales.first(where: {
                $0.language.languageCode == LocalizationKit.l10n.language
            }) ?? Locale(identifier: "en_US")

            self.instructions = self.localizedInstructions?.first(where: { $0.locale == currentLocale })?.value
        } else {
            self.instructions = nil
        }

        switch (self.interface, self.gameplay) {
            case (.touchToSelect, .findTheRightAnswers),
                 (.listenThenTouchToSelect, .findTheRightAnswers),
                 (.observeThenTouchToSelect, .findTheRightAnswers),
                 (.robotThenTouchToSelect, .findTheRightAnswers):
                self.payload = try container.decode(TouchToSelect.Payload.self, forKey: .payload)

            case (.dragAndDropIntoZones, .findTheRightAnswers),
                 (.listenThenDragAndDropIntoZones, .findTheRightAnswers),
                 (.observeThenDragAndDropIntoZones, .findTheRightAnswers),
                 (.robotThenDragAndDropIntoZones, .findTheRightAnswers):
                self.payload = try container.decode(DragAndDropIntoZones.Payload.self, forKey: .payload)

            case (.dragAndDropToAssociate, .associateCategories),
                 (.listenThenDragAndDropToAssociate, .associateCategories),
                 (.observeThenDragAndDropToAssociate, .associateCategories),
                 (.robotThenDragAndDropToAssociate, .associateCategories):
                self.payload = try container.decode(DragAndDropToAssociate.Payload.self, forKey: .payload)

            case (.dragAndDropInOrder, .findTheRightOrder):
                self.payload = try container.decode(DragAndDropInOrder.Payload.self, forKey: .payload)

            case (.memory, .associateCategories):
                self.payload = try container.decode(Memory.Payload.self, forKey: .payload)

            case (.danceFreeze, .none):
                self.payload = try container.decode(DanceFreeze.Payload.self, forKey: .payload)

            case (.musicalInstruments, .none):
                self.payload = try container.decode(MusicalInstrument.Payload.self, forKey: .payload)

            case (.melody, .none):
                self.payload = try container.decode(MidiRecordingPlayer.Payload.self, forKey: .payload)

            case (.superSimon, .none):
                self.payload = try container.decode(SuperSimon.Payload.self, forKey: .payload)

            case (.gamepadJoyStickColorPad, .none),
                 (.gamepadArrowPadColorPad, .none),
                 (.gamepadColorPad, .none),
                 (.gamepadArrowPad, .none),
                 (.hideAndSeek, .none),
                 (.colorMusicPad, .none),
                 (.pairing, .none):
                self.payload = nil

            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .payload, in: container, debugDescription: "Invalid combination of interface or gameplay"
                )
        }
    }

    // MARK: Public

    public let instructions: String?
    public let interface: Interface
    public let gameplay: Gameplay?
    public let action: Action?
    public let payload: ExercisePayloadProtocol?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case localizedInstructions = "instructions"
        case interface
        case gameplay
        case action
        case payload
    }

    // MARK: Private

    private let localizedInstructions: [LocalizedInstructions]?
}

// MARK: Exercise.LocalizedInstructions

public extension Exercise {
    struct LocalizedInstructions: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.value = try container.decode(String.self, forKey: .value)
        }

        // MARK: Internal

        let locale: Locale
        let value: String
    }
}
