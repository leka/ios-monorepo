// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MemoryViewViewModel

public class NewMemoryViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: MemoryGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiModel.value.choices
        self.coordinator = coordinator
        self.coordinator.uiModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiModel in
                self?.choices = uiModel.choices
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var choices: [MemoryUIChoiceModel]

    func onTapped(choice: MemoryUIChoiceModel) {
        self.coordinator.processUserSelection(choiceID: choice.id)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let coordinator: MemoryGameplayCoordinatorProtocol
}
