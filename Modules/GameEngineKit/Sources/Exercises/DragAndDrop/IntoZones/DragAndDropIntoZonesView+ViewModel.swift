// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension DragAndDropIntoZonesView {
    class ViewModel: ObservableObject {
        // MARK: Lifecycle

        init(choices: [DragAndDropIntoZones.Choice], shuffle: Bool = false, shared: ExerciseSharedData? = nil) {
            let gameplayChoiceModel = choices.map { GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones(choice: $0) }
            self.choices = shuffle ? gameplayChoiceModel.shuffled() : gameplayChoiceModel
            self.gameplay = GameplayFindTheRightAnswers(choices: gameplayChoiceModel)
            self.exercicesSharedData = shared ?? ExerciseSharedData()

            self.subscribeToGameplayDragAndDropChoicesUpdates()
            self.subscribeToGameplayStateUpdates()
        }

        // MARK: Public

        public func onChoiceDropped(
            choice: GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones, into dropZone: DragAndDropIntoZones.DropZone
        ) {
            var newChoice = choice
            newChoice.droppedIntoZone = dropZone
            self.gameplay.process(choice: newChoice)
        }

        // MARK: Internal

        @Published var choices: [GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones] = []
        @ObservedObject var exercicesSharedData: ExerciseSharedData

        // MARK: Private

        private let gameplay: GameplayFindTheRightAnswers<GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones>
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
