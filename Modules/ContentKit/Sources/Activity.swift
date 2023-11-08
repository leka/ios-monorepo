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
    public let shuffleSequences: Bool
    public var sequence: [ExerciseSequence]

    private enum CodingKeys: String, CodingKey {
        case id, name, description, image, sequence
        case shuffleSequences = "shuffle_sequences"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: .image)
        self.sequence = try container.decode([ExerciseSequence].self, forKey: .sequence)

        self.shuffleSequences = try container.decodeIfPresent(Bool.self, forKey: .shuffleSequences) ?? false
    }
}

public struct ExerciseSequence: Codable {
    public let exercises: [Exercise]
}

public enum ExerciseType: String, Codable {
    case selection
    case dragAndDrop
    case association
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
        case dragAndDrop
        case association
    }
}

public enum ExercisePayload: Codable {
    case selection(SelectionPayload)
    case dragAndDrop(DragAndDropPayload)
    case association(AssociationPayload)

    // TODO(@ladislas): see if we can decode based on interface in Exercise
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomKeys.self)

        // association
        if container.allKeys.contains(.category) {
            let category = try container.decode(String.self, forKey: .category)
            let choices = try container.decode([AssociationChoice].self, forKey: .choices)
            let shuffleChoices = try container.decodeIfPresent(Bool.self, forKey: .shuffleChoices) ?? false

            self = .association(
                AssociationPayload(category: category, choices: choices, shuffleChoices: shuffleChoices))
            return
        }

        // drag and drop
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
            let media = try? container.decode(String.self, forKey: .media)
            let shuffleChoices = try container.decodeIfPresent(Bool.self, forKey: .shuffleChoices) ?? false

            self = .selection(SelectionPayload(choices: choices, media: media, shuffleChoices: shuffleChoices))
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
            case .association(let payload):
                try container.encode(payload)
        }
    }

    private enum CustomKeys: String, CodingKey {
        case category, choices, dropZoneA, dropZoneB, media, payload
        case shuffleChoices = "shuffle_choices"
    }
}

public struct SelectionPayload: Codable {
    public let choices: [SelectionChoice]
    public let media: String?
    public let shuffleChoices: Bool
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
    public let dropZone: ChoiceDropZone?

    public enum ChoiceDropZone: String, Codable {
        case zoneA
        case zoneB
    }
}

public struct AssociationChoice: Codable {
    public let value: String
    public let type: UIElementType
    public let category: String

    private enum CodingKeys: String, CodingKey {
        case value, type, category
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        type = try container.decode(UIElementType.self, forKey: .type)
        category = try container.decode(String.self, forKey: .category)
    }

    public init(value: String, type: UIElementType, category: String) {
        self.value = value
        self.type = type
        self.category = category
    }
}

public struct AssociationPayload: Codable {
    public let category: String
    public let choices: [AssociationChoice]
    public let shuffleChoices: Bool
}
