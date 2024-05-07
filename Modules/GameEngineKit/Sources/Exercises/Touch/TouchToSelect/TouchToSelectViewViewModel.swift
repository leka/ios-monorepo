// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class TouchToSelectViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(gameplayType: Exercise.Gameplay, choices: [TouchToSelect.Choice], shuffle: Bool = false, shared: ExerciseSharedData? = nil) {
        switch gameplayType {
            case .findTheRightAnswers:
                self.gameplay = GameplayFindTheRightAnswers(
                    choices: choices.map { GameplayTouchToSelectChoiceModel(choice: $0) },
                    shuffle: shuffle
                )
            default:
                fatalError("Gameplay type \(gameplayType) is not compatible with TTSViewModel")
        }

        self.exercicesSharedData = shared ?? ExerciseSharedData()

        self.subscribeToGameplaySelectionChoicesUpdates()
        self.subscribeToGameplayStateUpdates()
    }

    // MARK: Public

    public func onChoiceTapped(choice: any GameplayChoiceModelProtocol) {
        if let gameplay = self.gameplay as? GameplayFindTheRightAnswers {
            guard let choice = choice as? GameplayTouchToSelectChoiceModel else {
                fatalError("Choice model incorrect")
            }
            gameplay.process(choice)
        } else {
            fatalError("Gameplay not supported by TouchToSelectViewModel")
        }
    }

    // MARK: Internal

    @Published var choices: [any GameplayChoiceModelProtocol] = []
    @ObservedObject var exercicesSharedData: ExerciseSharedData

    // MARK: Private

    private var gameplay: any StatefulGameplayProtocol & ChoiceProviderGameplayProtocol
    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToGameplaySelectionChoicesUpdates() {
        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink {
                if $0.isNotEmpty {
                    self.choices = $0
                }
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
