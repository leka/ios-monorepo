// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct TTSCoordinatorFindTheRightAnswersChoiceModel {
    // MARK: Lifecycle

    public init(id: String = UUID().uuidString, value: String, isRightAnswer: Bool, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.isRightAnswer = isRightAnswer
        self.type = type
    }

    // MARK: Internal

    let id: String
    let value: String
    let isRightAnswer: Bool
    let type: ChoiceType
}
