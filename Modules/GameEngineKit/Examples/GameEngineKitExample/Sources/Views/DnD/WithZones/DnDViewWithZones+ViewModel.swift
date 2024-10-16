// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - DnDViewWithZones+ViewModel

extension DnDViewWithZones {
    class ViewModel: ObservableObject {
        // MARK: Lifecycle

        init(coordinator: DnDCoordinatorWithZones) {
            self.choices = coordinator.uiChoices.value.choices
            self.dropzones = coordinator.uiDropZones
            self.coordinator = coordinator
            self.coordinator.uiChoices
                .receive(on: DispatchQueue.main)
                .sink { [weak self] choices in
                    self?.choices = choices.choices
                }
                .store(in: &self.cancellables)
        }

        // MARK: Public

        public func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDDropZoneNode? = nil) {
            self.coordinator.onTouch(event, choice: choice, destination: destination)
        }

        // MARK: Internal

        @Published var choices: [DnDAnswerNode] = []
        @Published var dropzones: [DnDDropZoneNode] = []

        // MARK: Private

        private let coordinator: DnDCoordinatorWithZones
        private var cancellables: Set<AnyCancellable> = []
    }
}
