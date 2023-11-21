// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct Exercise: Codable {

    public let instructions: String
    public let interface: Interface
    public let gameplay: Gameplay?
    public let action: Action?
    public let payload: ExercisePayloadProtocol?

    enum CodingKeys: String, CodingKey {
        case instructions, interface, gameplay, action, payload
    }

    public func encode(to encoder: Encoder) throws {
        fatalError("💥 Not implemented yet")
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.interface = try container.decode(Interface.self, forKey: .interface)
        self.gameplay = try container.decodeIfPresent(Gameplay.self, forKey: .gameplay)
        self.action = try container.decodeIfPresent(Action.self, forKey: .action)

        switch (interface, gameplay) {
            case (.touchToSelect, .findTheRightAnswers),
                (.listenThenTouchToSelect, .findTheRightAnswers),
                (.observeThenTouchToSelect, .findTheRightAnswers),
                (.robotThenTouchToSelect, .findTheRightAnswers):
                payload = try container.decode(TouchToSelect.Payload.self, forKey: .payload)

            case (.dragAndDropIntoZones, .findTheRightAnswers):
                payload = try container.decode(DragAndDropIntoZones.Payload.self, forKey: .payload)

            case (.dragAndDropToAssociate, .associateCategories):
                payload = try container.decode(DragAndDropToAssociate.Payload.self, forKey: .payload)

            case (.placeholderNoGameplay, .none):
                payload = nil

            case (.danceFreeze, .none):
                payload = try container.decode(AudioRecordingPlayer.Payload.self, forKey: .payload)

            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .payload, in: container, debugDescription: "Invalid combination of interface or gameplay")
        }
    }

}
