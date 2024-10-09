// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - DNDViewViewModel

class DNDViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(coordinator: DNDCoordinatorAssociateCategories) {
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

    public func onTouch(_ event: DNDTouchEvent, choice: DNDAnswerNode, destination: DNDAnswerNode? = nil) {
        self.coordinator.onTouch(event, choice: choice, destination: destination)
    }

    // MARK: Internal

    @Published var choices: [DNDAnswerNode] = []

    // MARK: Private

    private let coordinator: DNDCoordinatorAssociateCategories
    private var cancellables: Set<AnyCancellable> = []
}
