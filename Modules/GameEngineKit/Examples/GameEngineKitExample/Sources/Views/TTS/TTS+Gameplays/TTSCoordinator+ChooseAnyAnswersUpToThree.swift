// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorChooseAnyAnswersUpToThree

class TTSCoordinatorChooseAnyAnswersUpToThree: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayChooseAnyAnswersUpToThree) {
        self.gameplay = gameplay

        self.uiChoices.value = self.gameplay.choices.value.map { choice in
            TTSChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
        }

        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newChoices in
                guard let self else { return }

                self.uiChoices.value = newChoices.map { choice in
                    TTSChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
                }
            }
            .store(in: &self.cancellables)
    }

    // MARK: Public

    public static let kDefaultChoices: [FindTheRightAnswersChoice] = [
        FindTheRightAnswersChoice(value: "Choice 1\nCorrect", isRightAnswer: true),
        FindTheRightAnswersChoice(value: "Choice 2", isRightAnswer: false),
        FindTheRightAnswersChoice(value: "Choice 3\nCorrect", isRightAnswer: true),
        FindTheRightAnswersChoice(value: "Choice 4", isRightAnswer: false),
        FindTheRightAnswersChoice(value: "Choice 5\nCorrect", isRightAnswer: true),
        FindTheRightAnswersChoice(value: "Choice 6", isRightAnswer: false),
    ]

    // MARK: Internal

    private(set) var uiChoices = CurrentValueSubject<[TTSChoiceModel], Never>([])

    func processUserSelection(choice: TTSChoiceModel) {
        log.debug("[CO] \(choice.id) - \(choice.value.replacingOccurrences(of: "\n", with: " ")) - \(choice.state)")
        guard let correspondingGameChoice = self.gameplay.choices.value.first(where: { $0.id == choice.id }) else { return }
        self.gameplay.process(choice: correspondingGameChoice)
    }

    // MARK: Private

    private var gameplay: GameplayChooseAnyAnswersUpToThree

    private var cancellables = Set<AnyCancellable>()

    private static func stateConverter(from state: FindTheRightAnswersChoiceState) -> TTSChoiceState {
        switch state {
            case .idle:
                .idle
            case .selected:
                .selected
            default:
                .idle
        }
    }
}

#Preview {
    let gameplay = GameplayChooseAnyAnswersUpToThree(choices: TTSCoordinatorChooseAnyAnswersUpToThree.kDefaultChoices)
    let coordinator = TTSCoordinatorChooseAnyAnswersUpToThree(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
