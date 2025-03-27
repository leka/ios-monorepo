// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

class SuperSimonViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(level: SuperSimon.Level, shuffle _: Bool = false, shared: ExerciseSharedData? = nil) {
        self.gameplay = GameplaySuperSimon(level: level)
        self.exercicesSharedData = shared ?? ExerciseSharedData()

        self.subscribeToGameplaySelectionChoicesUpdates()
        self.subscribeToGameplayStateUpdates()

        self.subscribeToGameplayGameStateUpdates()

        self.enableChoices = false
    }

    // MARK: Public

    @Published public var enableChoices: Bool = false
    @Published public var disableRobot: Bool = true

    public func onChoiceTapped(choice: GameplaySuperSimonChoiceModel) {
        self.gameplay.process(choice: choice)
    }

    // MARK: Internal

    @ObservedObject var exercicesSharedData: ExerciseSharedData

    @Published var choices: [GameplaySuperSimonChoiceModel] = []

    func onRobotTapped() {
        self.gameplay.playColorSequence()
    }

    // MARK: Private

    private let gameplay: GameplaySuperSimon
    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToGameplaySelectionChoicesUpdates() {
        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink {
                self.choices = $0
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToGameplayStateUpdates() {
        self.gameplay.state
            .receive(on: DispatchQueue.main)
            .sink {
                self.exercicesSharedData.state = $0
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToGameplayGameStateUpdates() {
        self.gameplay.gameState
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                    case .showingColorSequence:
                        self.enableChoices = false
                        self.disableRobot = false
                    case .playingColorSequence:
                        self.enableChoices = false
                        self.disableRobot = true
                    case .waitingForUser:
                        self.enableChoices = true
                        self.disableRobot = false
                }
            }
            .store(in: &self.cancellables)
    }
}
