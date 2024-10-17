// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - DnDGridViewModel

class DnDGridViewModel: ObservableObject {
    // MARK: Lifecycle

    init(coordinator: DnDGridGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiChoices.value.choices
        self.coordinator = coordinator
        self.coordinator.uiChoices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] choices in
                self?.choices = choices.choices
            }
            .store(in: &self.cancellables)
    }

    // MARK: Public

    public func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDAnswerNode? = nil) {
        self.coordinator.onTouch(event, choice: choice, destination: destination)
    }

    // MARK: Internal

    @Published var choices: [DnDAnswerNode] = []

    // MARK: Private

    private let coordinator: DnDGridGameplayCoordinatorProtocol
    private var cancellables: Set<AnyCancellable> = []
}
