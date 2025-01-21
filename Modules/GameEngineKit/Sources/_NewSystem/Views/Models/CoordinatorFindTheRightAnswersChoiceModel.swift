// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct CoordinatorFindTheRightAnswersChoiceModel {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, isRightAnswer: Bool, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.isRightAnswer = isRightAnswer
        self.type = type
    }

    // MARK: Internal

    let id: UUID
    let value: String
    let isRightAnswer: Bool
    let type: ChoiceType
}
