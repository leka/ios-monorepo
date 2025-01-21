// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

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
