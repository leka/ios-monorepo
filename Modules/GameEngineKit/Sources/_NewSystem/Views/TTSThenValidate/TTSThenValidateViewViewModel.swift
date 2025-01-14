// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSThenValidateViewViewModel

public class TTSThenValidateViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: TTSThenValidateGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiModel.value.choices
        self.action = coordinator.uiModel.value.action
        self.coordinator = coordinator
        self.didTriggerAction = (self.action == nil) ? true : false
        self.coordinator.uiModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.choices = model.choices
            }
            .store(in: &self.cancellables)

        self.coordinator.validationEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] validationEnabled in
                self?.validationDisabled = !validationEnabled
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var didTriggerAction = false
    @Published var validationDisabled: Bool = true
    @Published var choices: [TTSUIChoiceModel]

    let action: Exercise.Action?

    func onTapped(choice: TTSUIChoiceModel) {
        self.coordinator.processUserSelection(choice: choice)
    }

    func onValidate() {
        self.coordinator.validateUserSelection()
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let coordinator: TTSThenValidateGameplayCoordinatorProtocol
}
