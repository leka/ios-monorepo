// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension DragAndDropAnyAnswerView {
    class ViewModel: ObservableObject {
        // MARK: Lifecycle

        init(choices: [DragAndDropAnyAnswer.Choice], shuffle: Bool = false, shared: ExerciseSharedData? = nil) {
            let gameplayChoiceModel = choices.map { GameplayChooseAnyAnswerChoiceModel(choice: $0) }
            self.choices = shuffle ? gameplayChoiceModel.shuffled() : gameplayChoiceModel
            self.gameplay = GameplayChooseAnyAnswer(choices: gameplayChoiceModel)
            self.exercicesSharedData = shared ?? ExerciseSharedData()

            self.subscribeToGameplayDragAndDropChoicesUpdates()
            self.subscribeToGameplayStateUpdates()
        }

        // MARK: Public

        public func onChoiceTapped(
            choice: GameplayChooseAnyAnswerChoiceModel, dropZone: DragAndDropAnyAnswer.DropZone
        ) {
            self.gameplay.process(choice, dropZone)
        }

        // MARK: Internal

        @Published var choices: [GameplayChooseAnyAnswerChoiceModel] = []
        @ObservedObject var exercicesSharedData: ExerciseSharedData

        // MARK: Private

        private let gameplay: GameplayChooseAnyAnswer<GameplayChooseAnyAnswerChoiceModel>
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
