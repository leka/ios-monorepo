// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class TouchToSelectViewViewModel: ObservableObject {

    @Published var choices: [GameplaySelectionChoiceModel] = []

    private let gameplay: GameplaySelectAllRightAnswers<GameplaySelectionChoiceModel>
    private var cancellables: Set<AnyCancellable> = []

    init(choices: [SelectionChoice]) {
        self.gameplay = GameplaySelectAllRightAnswers(
            choices: choices.map { GameplaySelectionChoiceModel(choice: $0) })
        subscribeToGameplaySelectionChoicesUpdates()
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

}
