// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public enum ExercisePayload: Codable {
    case selection(SelectionPayload)
    case dragAndDrop(DragAndDropPayload)

    // TODO(@ladislas): see if we can decode based on interface in Exercise
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomKeys.self)

        if container.allKeys.contains(.dropZoneA) {
            let dropZoneA = try container.decode(DropZoneDetails.self, forKey: .dropZoneA)
            let dropZoneB = try container.decodeIfPresent(DropZoneDetails.self, forKey: .dropZoneB)
            let choices = try container.decode([DragAndDropChoice].self, forKey: .choices)

            self = .dragAndDrop(DragAndDropPayload(dropZoneA: dropZoneA, dropZoneB: dropZoneB, choices: choices))
            return
        }

        // ? Selection
        if container.allKeys.contains(.choices) {
            let choices = try container.decode([SelectionChoice].self, forKey: .choices)
            let action = try? container.decode(Exercise.Action.self, forKey: .action)
            let shuffleChoices = try container.decodeIfPresent(Bool.self, forKey: .shuffleChoices) ?? false

            self = .selection(SelectionPayload(choices: choices, action: action, shuffleChoices: shuffleChoices))
            return
        }

        throw DecodingError.dataCorruptedError(
            forKey: CustomKeys.payload, in: container,
            debugDescription:
                "Cannot decode ExercisePayload. Available keys: \(container.allKeys.map { $0.stringValue })")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .selection(let payload):
                try container.encode(payload)
            case .dragAndDrop(let payload):
                try container.encode(payload)
        }
    }

    private enum CustomKeys: String, CodingKey {
        case choices, dropZoneA, dropZoneB, payload, action
        case shuffleChoices = "shuffle_choices"
    }
}
