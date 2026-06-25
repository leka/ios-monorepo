// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - DnDGridWithZonesViewViewModel

public class DnDGridWithZonesViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: DnDGridWithZonesGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiModel.value.choices
        self.dropzones = coordinator.uiDropZoneModel.zones
        self.action = coordinator.uiModel.value.action
        self.didTriggerAction = (self.action == nil) ? true : false
        self.coordinator = coordinator
        self.coordinator.uiModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.choices = model.choices
            }
            .store(in: &self.cancellables)

        self.coordinator.validationState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] validationState in
                self?.validationState = validationState
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var didTriggerAction = false
    @Published var validationState: ValidationState = .hidden
    @Published var choices: [DnDAnswerNode] = []
    @Published var dropzones: [DnDDropZoneNode] = []

    let action: NewExerciseAction?

    func onTouch(_ event: DnDTouchEvent, choiceID: UUID, destinationID: UUID? = nil) {
        self.coordinator.onTouch(event, choiceID: choiceID, destinationID: destinationID)
    }

    func onValidate() {
        self.coordinator.validateUserSelection()
    }

    // MARK: Private

    private let coordinator: DnDGridWithZonesGameplayCoordinatorProtocol
    private var cancellables: Set<AnyCancellable> = []
}
