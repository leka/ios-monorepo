// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

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

public struct SelectionPayload: Codable {
    public let choices: [SelectionChoice]
    public let action: Action?
    public let shuffleChoices: Bool
}
