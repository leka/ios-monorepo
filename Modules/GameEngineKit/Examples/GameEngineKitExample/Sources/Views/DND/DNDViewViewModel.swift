// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

extension DNDView {
    class ViewModel: ObservableObject {
        // MARK: Lifecycle

        init(coordinator: DNDCoordinatorAssociateCategories) {
            self.choices = coordinator.uiChoices.value
            self.coordinator = coordinator
            self.coordinator.uiChoices
                .receive(on: DispatchQueue.main)
                .sink { [weak self] choices in
                    self?.choices = choices
                }
                .store(in: &self.cancellables)
        }

        // MARK: Public

        public func onChoiceDropped(
            choice: DNDChoiceModel,
            destination: DNDChoiceModel
        ) {
            self.coordinator.processUserDrop(choice: choice, target: destination)
        }

        // MARK: Internal

        @Published var choices: [DNDChoiceModel] = []

        // MARK: Private

        private let coordinator: DNDCoordinatorAssociateCategories
        private var cancellables: Set<AnyCancellable> = []
    }
}
