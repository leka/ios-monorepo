// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

@Observable
class NewSuperSimonViewViewModel {
    // MARK: Lifecycle

    init(coordinator: NewSuperSimonCoordinator) {
        self.coordinator = coordinator

        self.subscribeToChoicesUpdates()
        self.subscribeToGameStateUpdates()

        self.didTriggerAction = false
    }

    // MARK: Public

    public var disableRobot: Bool = true

    // MARK: Internal

    var didTriggerAction = false
    var choices: [TTSUIChoiceModel] = []

    func onTapped(choiceID: UUID) {
        self.coordinator.processUserSelection(choiceID: choiceID)
    }

    func onRobotTapped() {
        self.coordinator.playColorSequence()
    }

    // MARK: Private

    private let coordinator: NewSuperSimonCoordinator
    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToChoicesUpdates() {
        self.coordinator.uiModel
            .receive(on: DispatchQueue.main)
            .sink {
                self.choices = $0.choices
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToGameStateUpdates() {
        self.coordinator.gameState
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                    case .showingColorSequence:
                        self.didTriggerAction = false
                        self.disableRobot = false
                    case .playingColorSequence:
                        self.didTriggerAction = false
                        self.disableRobot = true
                    case .waitingForUser:
                        self.didTriggerAction = true
                        self.disableRobot = false
                }
            }
            .store(in: &self.cancellables)
    }
}
