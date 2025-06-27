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
        self.validation = coordinator.validation
        self.coordinator.uiModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.choices = model.choices
            }
            .store(in: &self.cancellables)

        self.coordinator.validationEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] validationEnabled in
                self?.validationEnabled = validationEnabled
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var didTriggerAction = false
    @Published var validationEnabled: Bool?
    @Published var choices: [DnDAnswerNode] = []
    @Published var dropzones: [DnDDropZoneNode] = []

    let action: NewExerciseAction?
    let validation: NewExerciseOptions.Validation

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
