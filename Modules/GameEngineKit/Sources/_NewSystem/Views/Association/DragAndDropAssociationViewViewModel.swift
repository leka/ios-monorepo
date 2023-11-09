// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class DragAndDropAssociationViewViewModel: ObservableObject {

    @Published var choices: [GameplayAssociationChoiceModel] = []
    @ObservedObject var exercicesSharedData: ExerciseSharedData

    private let gameplay: GameplayAssociation<GameplayAssociationChoiceModel>
    private var cancellables: Set<AnyCancellable> = []

    init(choices: [AssociationChoice], shared: ExerciseSharedData? = nil) {
        let gameplayChoiceModel = choices.map { GameplayAssociationChoiceModel(choice: $0) }
        self.choices = gameplayChoiceModel
        self.gameplay = GameplayAssociation()
        self.exercicesSharedData = shared ?? ExerciseSharedData()

        subscribeToGameplayDragAndDropChoicesUpdates()
        subscribeToGameplayStateUpdates()
    }

    public func onChoiceTapped(choice: GameplayAssociationChoiceModel) {
        //        gameplay.process(choice)
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
