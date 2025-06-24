// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

extension DragAndDropInOrderView {
    class ViewModel: ObservableObject {
        // MARK: Lifecycle

        init(choices: [DragAndDropInOrder.Choice], shared: ExerciseSharedData? = nil) {
            let gameplayChoiceModel = choices.map { GameplayFindTheRightOrderChoiceModelDragAndDropInOrder(choice: $0) }
            var randomizedChoices = gameplayChoiceModel.shuffled()
            while randomizedChoices == gameplayChoiceModel {
                randomizedChoices = gameplayChoiceModel.shuffled()
            }
            self.choices = randomizedChoices
            self.gameplay = GameplayFindTheRightOrder(choices: gameplayChoiceModel)
            self.exercicesSharedData = shared ?? ExerciseSharedData()

            self.subscribeToGameplayDragAndDropChoicesUpdates()
            self.subscribeToGameplayStateUpdates()
        }

        // MARK: Public

        public func onChoiceDropped(choice: GameplayFindTheRightOrderChoiceModelDragAndDropInOrder, dropZoneIndex: Int) {
            var newChoice = choice
            newChoice.dropZoneIndex = dropZoneIndex
            self.gameplay.process(choice: newChoice)
        }

        public func onChoiceDroppedOutOfDropZone(choice: GameplayFindTheRightOrderChoiceModelDragAndDropInOrder) {
            self.gameplay.cancelChoice(choice)
        }

        // MARK: Internal

        @ObservedObject var exercicesSharedData: ExerciseSharedData

        @Published var choices: [GameplayFindTheRightOrderChoiceModelDragAndDropInOrder] = []

        // MARK: Private

        private let gameplay: GameplayFindTheRightOrder<GameplayFindTheRightOrderChoiceModelDragAndDropInOrder>
        private var cancellables: Set<AnyCancellable> = []

        private func subscribeToGameplayDragAndDropChoicesUpdates() {
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
