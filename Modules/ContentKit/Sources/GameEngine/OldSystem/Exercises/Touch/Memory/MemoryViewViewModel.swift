// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

class MemoryViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(choices: [Memory.Choice], shared: ExerciseSharedData? = nil, shuffleChoices: Bool = false) {
        let gameplayChoiceModel = shuffleChoices ? choices.map { GameplayAssociateCategoriesChoiceModelMemory(choice: $0) }.shuffled() : choices.map { GameplayAssociateCategoriesChoiceModelMemory(choice: $0) }
        self.gameplay = GameplayAssociateCategories(choices: gameplayChoiceModel)
        self.exercicesSharedData = shared ?? ExerciseSharedData()

        self.subscribeToGameplaySelectionChoicesUpdates()
        self.subscribeToGameplayStateUpdates()
        self.subscribeToIsTappableChanges()
    }

    // MARK: Public

    public func onChoiceTapped(choice: GameplayAssociateCategoriesChoiceModelMemory) {
        self.gameplay.process(choice: choice)
    }

    // MARK: Internal

    @ObservedObject var exercicesSharedData: ExerciseSharedData

    @Published var isTappable: Bool = false
    @Published var choices: [GameplayAssociateCategoriesChoiceModelMemory] = []

    // MARK: Private

    private let gameplay: GameplayAssociateCategories<GameplayAssociateCategoriesChoiceModelMemory>
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
