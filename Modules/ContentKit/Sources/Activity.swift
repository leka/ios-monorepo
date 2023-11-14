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
    case association
}

public struct Exercise: Codable {
    public let instructions: String
    public let type: ExerciseType
    public let interface: Interface
    public let gameplay: Gameplay
    public let payload: ExercisePayload

    public enum Interface: String, Codable {
        case touchToSelect
        case robotThenTouchToSelect
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
        // TODO(@ladislas): Add PayloadType to Payload
        let payloadType = try? container.decodeIfPresent(ExerciseType.self, forKey: .type)
        if case .association = payloadType {
            let type = try container.decode(ExerciseType.self, forKey: .type)
            let choices = try container.decode([AssociationChoice].self, forKey: .choices)
            let shuffleChoices = try container.decodeIfPresent(Bool.self, forKey: .shuffleChoices) ?? false

            self = .association(
                AssociationPayload(type: type, choices: choices, shuffleChoices: shuffleChoices))
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
            let action = try? container.decode(Action.self, forKey: .action)
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
            case .association(let payload):
                try container.encode(payload)
        }
    }

    private enum CustomKeys: String, CodingKey {
        case choices, dropZoneA, dropZoneB, payload, action, type
        case shuffleChoices = "shuffle_choices"
    }
}

public struct SelectionPayload: Codable {
    public let choices: [SelectionChoice]
    public let action: Action?
    public let shuffleChoices: Bool
}

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
                        "Cannot decode ExercisePayload. Available keys: \(container.allKeys.map { $0.stringValue })")
        }
    }
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

public protocol DraggableChoice {
    var value: String { get }
    var type: UIElementType { get }
}

public struct DragAndDropChoice: Codable, DraggableChoice {
    public let value: String
    public let type: UIElementType
    public let dropZone: ChoiceDropZone?

    public enum ChoiceDropZone: String, Codable {
        case zoneA
        case zoneB
    }
}

public struct AssociationChoice: Codable, DraggableChoice {
    public let value: String
    public let type: UIElementType
    public let category: AssociationCategory

    public enum AssociationCategory: String, Codable {
        case catA
        case catB
        case catC
    }

    private enum CodingKeys: String, CodingKey {
        case value, type, category
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        type = try container.decode(UIElementType.self, forKey: .type)
        category = try container.decode(AssociationCategory.self, forKey: .category)
    }

    public init(value: String, type: UIElementType, category: AssociationCategory) {
        self.value = value
        self.type = type
        self.category = category
    }
}

public struct AssociationPayload: Codable {
    public let type: ExerciseType
    public let choices: [AssociationChoice]
    public let shuffleChoices: Bool
}
