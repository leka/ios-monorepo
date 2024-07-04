// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension DragAndDropInOrderView {
    class ViewModel: ObservableObject {
        // MARK: Lifecycle

        init(choices: [DragAndDropInOrder.Choice], shared: ExerciseSharedData? = nil) {
            let gameplayChoiceModel = choices.map { GameplayDragAndDropInOrderChoiceModel(choice: $0) }
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

        public func onChoiceDropped(choice: GameplayDragAndDropInOrderChoiceModel, dropZoneIndex: Int) {
            self.gameplay.process(choice, dropZoneIndex)
        }

        public func onChoiceDroppedOutOfDropZone(choice: GameplayDragAndDropInOrderChoiceModel) {
            self.gameplay.cancelChoice(choice)
        }

        // MARK: Internal

        @Published var choices: [GameplayDragAndDropInOrderChoiceModel] = []
        @ObservedObject var exercicesSharedData: ExerciseSharedData

        // MARK: Private

        private let gameplay: GameplayFindTheRightOrder<GameplayDragAndDropInOrderChoiceModel>
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
