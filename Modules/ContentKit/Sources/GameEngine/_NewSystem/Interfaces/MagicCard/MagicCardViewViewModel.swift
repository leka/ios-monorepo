// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

// MARK: - MagicCardViewViewModel

public class MagicCardViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: MagicCardGameplayCoordinatorProtocol) {
        self.coordinator = coordinator
        self.choices = coordinator.uiModel.value.choices
        self.action = coordinator.uiModel.value.action
        self.didTriggerAction = self.action == nil
        self.coordinator.uiModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.choices = model.choices
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var didTriggerAction = true
    @Published var choices: [MagicCardUIChoiceModel]

    let action: NewExerciseAction?

    func enableMagicCardDetection() {
        self.coordinator.enableMagicCardDetection()
    }

    func onTapped(cardID: UUID) {
        self.coordinator.processUserSelection(cardID: cardID)
    }

    // MARK: Private

    private let coordinator: MagicCardGameplayCoordinatorProtocol
    private var cancellables = Set<AnyCancellable>()
}
