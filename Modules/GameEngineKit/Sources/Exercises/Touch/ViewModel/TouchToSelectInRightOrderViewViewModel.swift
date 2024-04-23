// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class TouchToSelectInRightOrderViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(choices: [TouchToSelectInRightOrder.Choice], shuffle: Bool = false, shared: ExerciseSharedData? = nil) {
        self.gameplay = GameplayFindTheRightAnswers(
            choices: choices.map { GameplayTouchToSelectInRightOrderChoiceModel(choice: $0) }, shuffle: shuffle
        )
        self.exercicesSharedData = shared ?? ExerciseSharedData()

        self.subscribeToGameplaySelectionChoicesUpdates()
        self.subscribeToGameplayStateUpdates()
    }

    // MARK: Public

    public func onChoiceTapped(choice: GameplayTouchToSelectInRightOrderChoiceModel) {
        self.gameplay.process(choice)
    }

    // MARK: Internal

    @Published var choices: [GameplayTouchToSelectInRightOrderChoiceModel] = []
    @ObservedObject var exercicesSharedData: ExerciseSharedData

    // MARK: Private

    private let gameplay: GameplayFindTheRightAnswers<GameplayTouchToSelectInRightOrderChoiceModel>
    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToGameplaySelectionChoicesUpdates() {
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
