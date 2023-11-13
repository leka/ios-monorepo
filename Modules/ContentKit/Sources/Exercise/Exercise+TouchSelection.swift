// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable nesting

public enum TouchSelection {

    public struct Choice: Codable {
        public let value: String
        public let type: Exercise.UIElementType
        public let isRightAnswer: Bool

        private enum CodingKeys: String, CodingKey {
            case value, type, isRightAnswer
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            value = try container.decode(String.self, forKey: .value)
            type = try container.decode(Exercise.UIElementType.self, forKey: .type)
            isRightAnswer = try container.decodeIfPresent(Bool.self, forKey: .isRightAnswer) ?? false
        }

        public init(value: String, type: Exercise.UIElementType, isRightAnswer: Bool = false) {
            self.value = value
            self.type = type
            self.isRightAnswer = isRightAnswer
        }
    }

    public struct Payload: Codable {
        public let choices: [Choice]
        public let shuffleChoices: Bool
    }

}

// swiftlint:enable nesting
