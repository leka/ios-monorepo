// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - ActionThenTTSViewViewModel

public class ActionThenTTSViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: ActionThenTTSGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiChoices.value.choices
        self.action = coordinator.uiChoices.value.action!
        self.coordinator = coordinator

        self.coordinator.uiChoices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiChoices in
                self?.choices = uiChoices.choices
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var choices: [ActionThenTTSViewUIChoiceModel]
    @Published var isActionTriggered = false

    let action: Exercise.Action

    func onTapped(choice: ActionThenTTSViewUIChoiceModel) {
        self.coordinator.processUserSelection(choice: choice)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let coordinator: ActionThenTTSGameplayCoordinatorProtocol
}
