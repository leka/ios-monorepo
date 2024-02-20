// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - Exercise

public struct Exercise: Codable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.interface = try container.decode(Interface.self, forKey: .interface)
        self.gameplay = try container.decodeIfPresent(Gameplay.self, forKey: .gameplay)
        self.action = try container.decodeIfPresent(Action.self, forKey: .action)

        self.l10nInstructions = try? container.decode([Instructions].self, forKey: .instructions)

        if let l10nInstructions = self.l10nInstructions {
            let availableLocales = l10nInstructions.map(\.locale)

            let currentLocale = availableLocales.first(where: {
                $0.language.languageCode == LocalizationKit.l10n.language
            }) ?? Locale(identifier: "en_US")

            self.instructions = self.l10nInstructions?.first(where: { $0.locale == currentLocale })?.value
        } else {
            self.instructions = nil
        }

        switch (self.interface, self.gameplay) {
            case (.touchToSelect, .findTheRightAnswers),
                 (.listenThenTouchToSelect, .findTheRightAnswers),
                 (.observeThenTouchToSelect, .findTheRightAnswers),
                 (.robotThenTouchToSelect, .findTheRightAnswers):
                self.payload = try container.decode(TouchToSelect.Payload.self, forKey: .payload)

            case (.dragAndDropIntoZones, .findTheRightAnswers):
                self.payload = try container.decode(DragAndDropIntoZones.Payload.self, forKey: .payload)

            case (.dragAndDropToAssociate, .associateCategories):
                self.payload = try container.decode(DragAndDropToAssociate.Payload.self, forKey: .payload)

            case (.danceFreeze, .none):
                self.payload = try container.decode(DanceFreeze.Payload.self, forKey: .payload)

            case (.musicalInstruments, .none):
                self.payload = try container.decode(MusicalInstrument.Payload.self, forKey: .payload)

            case (.melody, .none):
                self.payload = try container.decode(MidiRecordingPlayer.Payload.self, forKey: .payload)

            case (.remoteStandard, .none),
                 (.remoteArrow, .none),
                 (.hideAndSeek, .none),
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

    public func encode(to _: Encoder) throws {
        fatalError("💥 Not implemented yet")
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case instructions
        case interface
        case gameplay
        case action
        case payload
    }

    // MARK: Private

    private let l10nInstructions: [Instructions]?
}

// MARK: Exercise.Instructions

public extension Exercise {
    struct Instructions: Codable {
        let locale: Locale
        let value: String
    }
}
