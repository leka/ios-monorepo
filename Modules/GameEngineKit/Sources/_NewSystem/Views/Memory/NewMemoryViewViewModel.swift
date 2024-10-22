// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MemoryViewViewModel

public class NewMemoryViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: MemoryGameplayCoordinatorProtocol) {
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

    @Published var choices: [MemoryViewUIChoiceModel]

    func onTapped(choice: MemoryViewUIChoiceModel) {
        self.coordinator.processUserSelection(choice: choice)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let coordinator: MemoryGameplayCoordinatorProtocol
}
