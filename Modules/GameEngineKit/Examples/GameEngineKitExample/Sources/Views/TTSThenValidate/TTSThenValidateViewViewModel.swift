// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSThenValidateViewViewModel

class TTSThenValidateViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(coordinator: TTSThenValidateGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiChoices.value.choices
        self.coordinator = coordinator
        self.coordinator.uiChoices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiChoices in
                self?.choices = uiChoices.choices
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var choices: [TTSChoiceModel]

    func onChoiceTapped(choice: TTSChoiceModel) {
        self.coordinator.processUserSelection(choice: choice)
    }

    func onValidate() {
        self.coordinator.validateUserSelection()
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let coordinator: TTSThenValidateGameplayCoordinatorProtocol
}
