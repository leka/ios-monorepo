// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class MemoryViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(choices: [Memory.Choice], shared: ExerciseSharedData? = nil, shuffleChoices: Bool = false) {
        let gameplayChoiceModel = shuffleChoices ? choices.map { GameplayMemoryChoiceModel(choice: $0) }.shuffled() : choices.map { GameplayMemoryChoiceModel(choice: $0) }
        self.gameplay = GameplayAssociateCategories(choices: gameplayChoiceModel)
        self.exercicesSharedData = shared ?? ExerciseSharedData()

        self.subscribeToGameplaySelectionChoicesUpdates()
        self.subscribeToGameplayStateUpdates()
        self.subscribeToIsTappableChanges()
    }

    // MARK: Public

    public func onChoiceTapped(choice: GameplayMemoryChoiceModel) {
        self.gameplay.process(choice)
    }

    // MARK: Internal

    @Published var isTappable: Bool = false
    @Published var choices: [GameplayMemoryChoiceModel] = []
    @ObservedObject var exercicesSharedData: ExerciseSharedData

    // MARK: Private

    private let gameplay: GameplayAssociateCategories<GameplayMemoryChoiceModel>
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

    private func subscribeToIsTappableChanges() {
        self.gameplay.isTappable
            .receive(on: DispatchQueue.main)
            .sink {
                self.isTappable = $0
            }
            .store(in: &self.cancellables)
    }
}