// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable nesting

public enum DragAndDropAnyAnswer {
    public enum DropZone: String, Codable {
        case zoneA
        case zoneB

        // MARK: Public

        public struct Details: Codable {
            public let value: String
            public let type: Exercise.UIElementType
        }
    }

    public struct Choice: Codable {
        public let value: String
        public let type: Exercise.UIElementType
    }

    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.dropZoneA = try container.decode(DropZone.Details.self, forKey: .dropZoneA)
            self.dropZoneB = try container.decodeIfPresent(DropZone.Details.self, forKey: .dropZoneB)
            self.choices = try container.decode([Choice].self, forKey: .choices)
            self.shuffleChoices = try container.decodeIfPresent(Bool.self, forKey: .shuffleChoices) ?? false
        }

        // MARK: Public

        public let dropZoneA: DropZone.Details
        public let dropZoneB: DropZone.Details?
        public let choices: [Choice]
        public let shuffleChoices: Bool

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case dropZoneA
            case dropZoneB
            case choices
            case shuffleChoices = "shuffle_choices"
        }
    }
}

// swiftlint:enable nesting
