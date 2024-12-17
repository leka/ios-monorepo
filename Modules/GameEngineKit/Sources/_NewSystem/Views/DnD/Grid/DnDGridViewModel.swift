// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - DnDGridViewModel

public class DnDGridViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(coordinator: DnDGridGameplayCoordinatorProtocol) {
        self.choices = coordinator.uiModel.value.choices
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

    // MARK: Public

    public func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDAnswerNode? = nil) {
        self.coordinator.onTouch(event, choice: choice, destination: destination)
    }

    // MARK: Internal

    @Published var isActionTriggered = false
    @Published var choices: [DnDAnswerNode] = []

    let action: Exercise.Action?

    // MARK: Private

    private let coordinator: DnDGridGameplayCoordinatorProtocol
    private var cancellables: Set<AnyCancellable> = []
}
