// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorFindTheRightAnswersChoiceModel

// swiftlint:disable:next type_name
public struct CoordinatorFindTheRightAnswersChoiceModel {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, type: ChoiceType = .text, isRightAnswer: Bool = false) {
        self.id = id
        self.value = value
        self.isRightAnswer = isRightAnswer
        self.type = type
    }

    // MARK: Internal

    let id: UUID
    let value: String
    let type: ChoiceType
    let isRightAnswer: Bool
}

// MARK: Decodable

extension CoordinatorFindTheRightAnswersChoiceModel: Decodable {
    public init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)

        self.value = try container.decode(String.self, forKey: .value)
        self.type = try container.decode(ChoiceType.self, forKey: .type)
        self.isRightAnswer = try container.decodeIfPresent(Bool.self, forKey: .isRightAnswer) ?? false

        self.id = UUID()
    }

    enum CodingKeys: String, CodingKey {
        case value
        case type
        case isRightAnswer = "is_right_answer"
    }
}
