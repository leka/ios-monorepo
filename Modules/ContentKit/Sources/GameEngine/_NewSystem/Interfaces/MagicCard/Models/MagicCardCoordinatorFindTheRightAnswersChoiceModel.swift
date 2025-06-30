// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import RobotKit

// MARK: - MagicCardCoordinatorFindTheRightAnswersChoiceModel

public struct MagicCardCoordinatorFindTheRightAnswersChoiceModel {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: MagicCard, isRightAnswer: Bool = false) {
        self.id = id
        self.value = value
        self.isRightAnswer = isRightAnswer
    }

    // MARK: Internal

    let id: UUID
    let value: MagicCard
    let isRightAnswer: Bool
}

// MARK: Decodable

extension MagicCardCoordinatorFindTheRightAnswersChoiceModel: Decodable {
    public init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)

        let magicCardName = try container.decode(String.self, forKey: .value)
        self.value = MagicCard(name: magicCardName)
        self.isRightAnswer = try container.decodeIfPresent(Bool.self, forKey: .isRightAnswer) ?? false

        self.id = UUID()
    }

    enum CodingKeys: String, CodingKey {
        case value
        case isRightAnswer = "is_right_answer"
    }
}
