// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - DnDGridWithZonesViewViewModel

public class DnDGridWithZonesViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: DnDGridWithZonesGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiModel.value.choices
        self.dropzones = coordinator.uiDropZoneModel.zones
        self.action = coordinator.uiModel.value.action
        self.isActionTriggered = (self.action == nil) ? true : false
        self.coordinator = coordinator
        self.coordinator.uiModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.choices = model.choices
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var isActionTriggered = false
    @Published var choices: [DnDAnswerNode] = []
    @Published var dropzones: [DnDDropZoneNode] = []

    let action: Exercise.Action?

    func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDDropZoneNode? = nil) {
        self.coordinator.onTouch(event, choice: choice, destination: destination)
    }

    // MARK: Private

    private let coordinator: DnDGridWithZonesGameplayCoordinatorProtocol
    private var cancellables: Set<AnyCancellable> = []
}
