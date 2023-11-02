// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class DragAndDropViewViewModel: ObservableObject {

    @Published var choices: [GameplayDragAndDropChoiceModel] = []
    @ObservedObject var exercicesSharedData: ExerciseSharedData

    private let gameplay: GameplaySelectAllRightAnswers<GameplayDragAndDropChoiceModel>
    private var cancellables: Set<AnyCancellable> = []

    init(choices: [DragAndDropChoice], shared: ExerciseSharedData? = nil) {
        let gameplayChoiceModel = choices.map { GameplayDragAndDropChoiceModel(choice: $0) }
        self.choices = gameplayChoiceModel
        self.gameplay = GameplaySelectAllRightAnswers(
            choices: gameplayChoiceModel)
        self.exercicesSharedData = shared ?? ExerciseSharedData()

        subscribeToGameplayDragAndDropChoicesUpdates()
        subscribeToGameplayStateUpdates()
    }

    public func onChoiceTapped(choice: GameplayDragAndDropChoiceModel, dropZone: DragAndDropChoice.ChoiceDropZone) {
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
