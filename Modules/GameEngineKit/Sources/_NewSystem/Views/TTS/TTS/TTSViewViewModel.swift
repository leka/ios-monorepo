// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSViewViewModel

public class TTSViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: TTSGameplayCoordinatorProtocol) {
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

    @Published var choices: [TTSViewUIChoiceModel]

    func onTapped(choice: TTSViewUIChoiceModel) {
        self.coordinator.processUserSelection(choice: choice)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let coordinator: TTSGameplayCoordinatorProtocol
}
