// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSViewViewModel

class TTSViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(coordinator: TTSGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiChoices.value
        self.coordinator = coordinator
        self.coordinator.uiChoices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] choices in
                self?.choices = choices
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var choices: [TTSChoiceModel]

    func onTapped(choice: TTSChoiceModel) {
        log.debug("[VM] \(choice.id) - \(choice.value.replacingOccurrences(of: "\n", with: " ")) - \(choice.state)")
        self.coordinator.processUserSelection(choice: choice)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let coordinator: TTSGameplayCoordinatorProtocol
}
