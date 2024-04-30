// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class TouchToSelectViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(gameplayType: Exercise.Gameplay, choices: [TouchToSelect.Choice], shuffle: Bool = false, shared: ExerciseSharedData? = nil) {
        self.gameplayType = gameplayType

        self.gameplay = gameplayType == .findTheRightAnswers ? GameplayFindTheRightAnswers(
            choices: choices.map { GameplayTouchToSelectChoiceModel(choice: $0) }, shuffle: shuffle
        ) : nil

        self.gameplayInRightOrder = gameplayType == .findTheRightAnswersInRightOrder ? GameplayFindTheRightAnswers(
            choices: choices.map { GameplayTouchToSelectInRightOrderChoiceModel(choice: $0) }, shuffle: shuffle
        ) : nil

        self.exercicesSharedData = shared ?? ExerciseSharedData()

        self.subscribeToGameplaySelectionChoicesUpdates()
        self.subscribeToGameplayStateUpdates()
    }

    // MARK: Public

    public func onChoiceTapped(choice: GameplayTouchToSelectChoiceModel) {
        log.info("onChoiceTapped GameplayTouchToSelectChoiceModel called")
        self.gameplay?.process(choice: choice)
    }

    public func onChoiceTapped(choice: GameplayTouchToSelectInRightOrderChoiceModel) {
        log.info("onChoiceTapped GameplayTouchToSelectInRightOrderChoiceModel called")
        self.gameplayInRightOrder?.process(choice: choice)
    }

    // MARK: Internal

    @Published var gameplayType: Exercise.Gameplay
    @Published var choices: [GameplayTouchToSelectChoiceModel] = []
    @ObservedObject var exercicesSharedData: ExerciseSharedData

    // MARK: Private

    private let gameplay: GameplayFindTheRightAnswers<GameplayTouchToSelectChoiceModel>?
    private var gameplayInRightOrder: GameplayFindTheRightAnswers<GameplayTouchToSelectInRightOrderChoiceModel>?
    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToGameplaySelectionChoicesUpdates() {
        self.gameplay?.choices
            .receive(on: DispatchQueue.main)
            .sink {
                if $0.isNotEmpty {
                    self.choices = $0
                }
            }
            .store(in: &self.cancellables)

        self.gameplayInRightOrder?.choices
            .receive(on: DispatchQueue.main)
            .sink {
                if $0.isNotEmpty {
//                    self.choices = $0
                }
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToGameplayStateUpdates() {
        self.gameplay?.state
            .receive(on: DispatchQueue.main)
            .sink {
                self.exercicesSharedData.state = $0
            }
            .store(in: &self.cancellables)

        self.gameplayInRightOrder?.state
            .receive(on: DispatchQueue.main)
            .sink {
                self.exercicesSharedData.state = $0
            }
            .store(in: &self.cancellables)
    }
}
