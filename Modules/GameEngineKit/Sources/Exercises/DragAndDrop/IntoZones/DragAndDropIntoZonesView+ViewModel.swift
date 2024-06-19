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
            let gameplayChoiceModel = choices.map { GameplayDragAndDropIntoZonesChoiceModel(choice: $0) }
            self.choices = shuffle ? gameplayChoiceModel.shuffled() : gameplayChoiceModel
            self.gameplay = GameplayFindTheRightAnswers(choices: gameplayChoiceModel)
            self.exercicesSharedData = shared ?? ExerciseSharedData()

            self.subscribeToGameplayDragAndDropChoicesUpdates()
            self.subscribeToGameplayStateUpdates()
            self.subscribeToExercicesSharedDataState()
        }

        // MARK: Public

        public func onChoiceTapped(
            choice: GameplayDragAndDropIntoZonesChoiceModel, dropZone: DragAndDropIntoZones.DropZone
        ) {
            self.gameplay.process(choice, dropZone)
        }

        public func subscribeToExercicesSharedDataState() {
            self.exercicesSharedData.$state
                .receive(on: DispatchQueue.main)
                .sink { [weak self] state in
                    guard let self else { return }
                    if state == .saving {
                        self.gameplay.setCompletionData()
                    }
                }
                .store(in: &self.cancellables)
        }

        // MARK: Internal

        @Published var choices: [GameplayDragAndDropIntoZonesChoiceModel] = []
        @ObservedObject var exercicesSharedData: ExerciseSharedData

        // MARK: Private

        private let gameplay: GameplayFindTheRightAnswers<GameplayDragAndDropIntoZonesChoiceModel>
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
