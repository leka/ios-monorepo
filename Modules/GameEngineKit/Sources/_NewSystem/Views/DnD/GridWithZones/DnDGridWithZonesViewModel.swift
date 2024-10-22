// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - DnDGridWithZonesViewViewModel

public class DnDGridWithZonesViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: DnDGridWithZonesGameplayCoordinatorProtocol) {
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

    // MARK: Internal

    @Published var choices: [DnDAnswerNode] = []
    @Published var dropzones: [DnDDropZoneNode] = []

    func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDDropZoneNode? = nil) {
        self.coordinator.onTouch(event, choice: choice, destination: destination)
    }

    // MARK: Private

    private let coordinator: DnDGridWithZonesGameplayCoordinatorProtocol
    private var cancellables: Set<AnyCancellable> = []
}
