// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class SelectionViewViewModel: ObservableObject {

    @Published var choices: [GameplaySelectionChoiceModel] = []
    @ObservedObject var exercicesSharedData: ExerciseSharedData

    private let gameplay: GameplaySelectAllRightAnswers<GameplaySelectionChoiceModel>
    private var cancellables: Set<AnyCancellable> = []

    init(choices: [TouchToSelect.Choice], shuffle: Bool = false, shared: ExerciseSharedData? = nil) {
        self.gameplay = GameplaySelectAllRightAnswers(
            choices: choices.map { GameplaySelectionChoiceModel(choice: $0) }, shuffle: shuffle)
        self.exercicesSharedData = shared ?? ExerciseSharedData()

        subscribeToGameplaySelectionChoicesUpdates()
        subscribeToGameplayStateUpdates()
    }

    public func onChoiceTapped(choice: GameplaySelectionChoiceModel) {
        gameplay.process(choice)
    }

    private func subscribeToGameplaySelectionChoicesUpdates() {
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
