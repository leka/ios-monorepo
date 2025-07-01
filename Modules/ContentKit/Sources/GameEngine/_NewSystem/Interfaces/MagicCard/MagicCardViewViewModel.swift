// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

// MARK: - MagicCardViewViewModel

public class MagicCardViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: MagicCardGameplayCoordinatorProtocol) {
        self.action = coordinator.action
        self.coordinator = coordinator
    }

    // MARK: Internal

    @Published var didTriggerAction = true

    let action: NewExerciseAction?

    func enableMagicCardDetection() {
        self.coordinator.enableMagicCardDetection()
    }

    func onValidateCorrectAnswer() {
        self.coordinator.validateCorrectAnswer()
    }

    // MARK: Private

    private let coordinator: MagicCardGameplayCoordinatorProtocol
}
