// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable nesting

public enum DragAndDropInOrder {
    public struct Choice: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try container.decode(String.self, forKey: .value)
            self.type = try container.decode(Exercise.UIElementType.self, forKey: .type)
        }

        public init(value: String, type: Exercise.UIElementType) {
            self.value = value
            self.type = type
        }

        // MARK: Public

        public let value: String
        public let type: Exercise.UIElementType

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case value
            case type
        }
    }

    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.choices = try container.decode([Choice].self, forKey: .choices)
        }

        // MARK: Public

        public let choices: [Choice]

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case choices
        }
    }
}

// swiftlint:enable nesting
