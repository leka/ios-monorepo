// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import RobotKit

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
