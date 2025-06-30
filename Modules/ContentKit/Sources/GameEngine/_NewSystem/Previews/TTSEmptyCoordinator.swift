// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

#if DEBUG

    class TTSEmptyCoordinator: TTSGameplayCoordinatorProtocol {
        // MARK: Lifecycle

        init(choices: [TTSUIChoiceModel] = kDefaultChoices) {
            self.uiModel = CurrentValueSubject<TTSUIModel, Never>(TTSUIModel(action: nil, choices: choices))
        }

        // MARK: Public

        public static let kDefaultChoices: [TTSUIChoiceModel] = [
            .init(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
            .init(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 2", type: .text, size: 240, state: .idle)),
            .init(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 3\nCorrect", type: .text, size: 240, state: .correct)),
            .init(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "}.triangle.fill", type: .sfsymbol, size: 240, state: .wrong)),
            .init(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 5", type: .text, size: 240, state: .idle)),
            .init(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 6", type: .text, size: 240, state: .idle)),
        ]

        // MARK: Internal

        var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
        var validationState = CurrentValueSubject<ValidationState, Never>(.hidden)
        var validation: NewExerciseOptions.Validation = .automatic

        func validateUserSelection() {
            logGEK.debug("Choice validated")
        }

        func processUserSelection(choiceID: UUID) {
            logGEK.debug("\(choiceID.uuidString) selected")
        }
    }

#endif
