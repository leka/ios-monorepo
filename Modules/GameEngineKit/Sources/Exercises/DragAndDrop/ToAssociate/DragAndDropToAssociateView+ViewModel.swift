// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension DragAndDropToAssociateView {
    class ViewModel: ObservableObject {
        // MARK: Lifecycle

        init(
            choices: [DragAndDropToAssociate.Choice],
            shuffle: Bool = false,
            shared: ExerciseSharedData? = nil
        ) {
            let gameplayChoiceModel = choices.map { GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate(choice: $0) }
            self.choices = shuffle ? gameplayChoiceModel.shuffled() : gameplayChoiceModel
            self.gameplay = GameplayAssociateCategories(choices: gameplayChoiceModel)
            self.exercicesSharedData = shared ?? ExerciseSharedData()

            self.subscribeToGameplayAssociateCategoriesChoicesUpdates()
            self.subscribeToGameplayStateUpdates()
        }

        // MARK: Public

        public func onChoiceDropped(
            choice: GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate, destination: GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate
        ) {
            var newChoice = choice
            newChoice.destination = destination
            self.gameplay.process(choice: newChoice)
        }

        // MARK: Internal

        @Published var choices: [GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate] = []
        @ObservedObject var exercicesSharedData: ExerciseSharedData

        // MARK: Private

        private let gameplay: GameplayAssociateCategories<GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate>
        private var cancellables: Set<AnyCancellable> = []

        private func subscribeToGameplayAssociateCategoriesChoicesUpdates() {
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
    }
}
