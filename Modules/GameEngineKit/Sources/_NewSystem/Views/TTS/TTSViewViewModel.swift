// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSViewViewModel

public class TTSViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: TTSGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiModel.value.choices
        self.action = coordinator.uiModel.value.action
        self.didTriggerAction = (self.action == nil) ? true : false
        self.coordinator = coordinator
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
    @Published var choices: [TTSUIChoiceModel]

    let action: Exercise.Action?

    func onTapped(choice: TTSUIChoiceModel) {
        self.coordinator.processUserSelection(choiceID: choice.id)
    }

    func onValidate() {
        self.coordinator.validateUserSelection()
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let coordinator: TTSGameplayCoordinatorProtocol
}
