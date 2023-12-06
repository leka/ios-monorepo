// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension DragAndDropIntoZonesView {
    class ViewModel: ObservableObject {
        @Published var choices: [GameplayDragAndDropIntoZonesChoiceModel] = []
        @ObservedObject var exercicesSharedData: ExerciseSharedData

        private let gameplay: GameplayFindTheRightAnswers<GameplayDragAndDropIntoZonesChoiceModel>
        private var cancellables: Set<AnyCancellable> = []

        init(choices: [DragAndDropIntoZones.Choice], shared: ExerciseSharedData? = nil) {
            let gameplayChoiceModel = choices.map { GameplayDragAndDropIntoZonesChoiceModel(choice: $0) }
            self.choices = gameplayChoiceModel
            self.gameplay = GameplayFindTheRightAnswers(
                choices: gameplayChoiceModel)
            self.exercicesSharedData = shared ?? ExerciseSharedData()

            subscribeToGameplayDragAndDropChoicesUpdates()
            subscribeToGameplayStateUpdates()
        }

        public func onChoiceTapped(
            choice: GameplayDragAndDropIntoZonesChoiceModel, dropZone: DragAndDropIntoZones.DropZone
        ) {
            gameplay.process(choice, dropZone)
        }

        private func subscribeToGameplayDragAndDropChoicesUpdates() {
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
