// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class TouchToSelectViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(choices: [TouchToSelect.Choice], shuffle: Bool = false, shared: ExerciseSharedData? = nil) {
        self.gameplay = GameplayFindTheRightAnswers(
            choices: choices.map { GameplayTouchToSelectChoiceModel(choice: $0) }, shuffle: shuffle
        )
        self.exercicesSharedData = shared ?? ExerciseSharedData()

        self.subscribeToGameplaySelectionChoicesUpdates()
        self.subscribeToGameplayStateUpdates()
        self.subscribeToExercicesSharedDataState()
    }

    // MARK: Public

    public func onChoiceTapped(choice: GameplayTouchToSelectChoiceModel) {
        self.gameplay.process(choice)
    }

    public func subscribeToExercicesSharedDataState() {
        self.exercicesSharedData.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                if state == .saving {
                    print("BEH Ecoute oui")
                    self.gameplay.setCompletionData()
                }
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var choices: [GameplayTouchToSelectChoiceModel] = []
    @ObservedObject var exercicesSharedData: ExerciseSharedData

    // MARK: Private

    private let gameplay: GameplayFindTheRightAnswers<GameplayTouchToSelectChoiceModel>
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
