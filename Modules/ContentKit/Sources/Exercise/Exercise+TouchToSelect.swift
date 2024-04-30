// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable nesting

public enum TouchToSelect {
    public struct Choice: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try container.decode(String.self, forKey: .value)
            self.type = try container.decode(Exercise.UIElementType.self, forKey: .type)
            self.isRightAnswer = try container.decodeIfPresent(Bool.self, forKey: .isRightAnswer) ?? false
            self.order = try container.decodeIfPresent(Int.self, forKey: .order) ?? -1
        }

        public init(value: String, type: Exercise.UIElementType, isRightAnswer: Bool = false, order: Int = -1) {
            self.value = value
            self.type = type
            self.isRightAnswer = isRightAnswer
            self.order = order
        }

        // MARK: Public

        public let value: String
        public let type: Exercise.UIElementType
        public let isRightAnswer: Bool
        public let order: Int

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case value
            case type
            case isRightAnswer = "is_right_answer"
            case order
        }
    }

    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.choices = try container.decode([Choice].self, forKey: .choices)

            self.shuffleChoices = try container.decodeIfPresent(Bool.self, forKey: .shuffleChoices) ?? false
        }

        // MARK: Public

        public let choices: [Choice]
        public let shuffleChoices: Bool

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case choices
            case shuffleChoices = "shuffle_choices"
        }
    }
}

// swiftlint:enable nesting
