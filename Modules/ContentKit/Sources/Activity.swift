// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

public struct Activity: Codable, Identifiable {
    public let id: String
    public let name: String
    public let description: String
    public let image: String
    public let sequence: [ExerciseSequence]
}

public struct ExerciseSequence: Codable {
    public let exercises: [Exercise]
}

public enum ExerciseType: String, Codable {
    case selection
    case dragAndDrop
}

public enum Gameplay: String, Codable {
    case selectAllRightAnswers
}

public struct Exercise: Codable {
    public let instructions: String
    public let type: ExerciseType
    public let interface: Interface
    public let gameplay: Gameplay
    public let payload: ExercisePayload

    public enum Interface: String, Codable {
        case touchToSelect
        case listenThenTouchToSelect
        case observeThenTouchToSelect
    }
}

public enum ExercisePayload: Codable {
    case selection(SelectionPayload)
    case dragAndDrop(DragAndDropPayload)

    // TODO(@ladislas): see if we can decode based on interface in Exercise
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomKeys.self)

        // ? Drag and drop
        // TODO(@ladislas): not working, implement real logic
        if container.allKeys.contains(.dropZoneA) {
            if let payload = try? container.decode(DragAndDropPayload.self, forKey: .dropZoneA) {
                self = .dragAndDrop(payload)
                return
            }
        }

        // ? Selection
        if container.allKeys.contains(.choices) {
            let choices = try container.decode([SelectionChoice].self, forKey: .choices)
            let media = try? container.decode(String.self, forKey: .media)

            self = .selection(SelectionPayload(choices: choices, media: media))
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
        case choices, dropZoneA, payload, media
    }
}

public struct SelectionPayload: Codable {
    public let choices: [SelectionChoice]
    public let media: String?
}

public enum UIElementType: String, Codable {
    case image
    case text
    case color
}

public struct SelectionChoice: Codable {
    public let value: String
    public let type: UIElementType
    public let isRightAnswer: Bool

    private enum CodingKeys: String, CodingKey {
        case value, type, isRightAnswer
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        type = try container.decode(UIElementType.self, forKey: .type)
        isRightAnswer = try container.decodeIfPresent(Bool.self, forKey: .isRightAnswer) ?? false
    }

    public init(value: String, type: UIElementType, isRightAnswer: Bool = false) {
        self.value = value
        self.type = type
        self.isRightAnswer = isRightAnswer
    }
}

public struct DragAndDropPayload: Codable {
    public let dropZoneA: DropZoneDetails
    public let dropZoneB: DropZoneDetails?
    public let choices: [DragAndDropChoice]
}

public struct DropZoneDetails: Codable {
    public let value: String
    public let type: UIElementType
}

public struct DragAndDropChoice: Codable {
    public let value: String
    public let type: UIElementType
    public let dropZone: ChoiceDropZone

    public enum ChoiceDropZone: String, Codable {
        case zoneA
        case zoneB
    }
}
