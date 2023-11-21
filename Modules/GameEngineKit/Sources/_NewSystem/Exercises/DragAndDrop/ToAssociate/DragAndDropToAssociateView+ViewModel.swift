// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension DragAndDropToAssociateView {

    class ViewModel: ObservableObject {

        @Published var choices: [GameplayAssociateCategoriesChoiceModel] = []
        @ObservedObject var exercicesSharedData: ExerciseSharedData

        private let gameplay: GameplayAssociateCategories<GameplayAssociateCategoriesChoiceModel>
        private var cancellables: Set<AnyCancellable> = []

        init(
            choices: [DragAndDropToAssociate.Choice],
            shuffle: Bool = false,
            shared: ExerciseSharedData? = nil
        ) {
            let gameplayChoiceModel = choices.map { GameplayAssociateCategoriesChoiceModel(choice: $0) }
            self.choices = shuffle ? gameplayChoiceModel.shuffled() : gameplayChoiceModel
            self.gameplay = GameplayAssociateCategories(choices: gameplayChoiceModel, shuffle: shuffle)
            self.exercicesSharedData = shared ?? ExerciseSharedData()

            subscribeToGameplayAssociateCategoriesChoicesUpdates()
            subscribeToGameplayStateUpdates()
        }

        public func onChoiceTapped(
            choice: GameplayAssociateCategoriesChoiceModel, destination: GameplayAssociateCategoriesChoiceModel
        ) {
            gameplay.process(choice, destination)
        }

        private func subscribeToGameplayAssociateCategoriesChoicesUpdates() {
            gameplay.choices
                .receive(on: DispatchQueue.main)
                .sink {
                    self.choices = $0
                }
                .store(in: &cancellables)
        }

        private func subscribeToGameplayStateUpdates() {
            gameplay.state
                .receive(on: DispatchQueue.main)
                .sink {
                    self.exercicesSharedData.state = $0
                }
                .store(in: &cancellables)
        }

    }

}
