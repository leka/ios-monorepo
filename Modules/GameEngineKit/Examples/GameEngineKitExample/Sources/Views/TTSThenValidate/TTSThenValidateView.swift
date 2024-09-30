// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSView

struct TTSThenValidateView: View {
    // MARK: Lifecycle

    init(viewModel: TTSThenValidateViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Internal

    @StateObject var viewModel: TTSThenValidateViewViewModel

    var body: some View {
        VStack(spacing: 100) {
            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[0...2]) { choice in
                    choice.view
                        .onTapGesture {
                            self.viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }

            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[3...5]) { choice in
                    choice.view
                        .onTapGesture {
                            self.viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }

            Button("Validate") {
                self.viewModel.onValidate()
            }
            .tint(.green)
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    // MARK: - TTSEmptyCoordinator

    class TTSEmptyCoordinator: TTSThenValidateGameplayCoordinatorProtocol {
        var uiChoices = CurrentValueSubject<UIChoices, Never>(UIChoices(choices: [
            TTSChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
            TTSChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 2\nSelected", type: .text,
                                                                                          size: 240, state: .selected)),
            TTSChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 3\nCorrect", type: .text,
                                                                                          size: 240, state: .correct)),
            TTSChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "exclamationmark.triangle.fill", type: .sfsymbol,
                                                                                          size: 240, state: .wrong)),
            TTSChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 5", type: .text, size: 240, state: .idle)),
            TTSChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 6", type: .text, size: 240, state: .idle)),
        ]))

        func processUserSelection(choice: TTSChoiceModel) {
            log.debug("\(choice.id)")
        }

        func validateUserSelection() {
            log.debug("Validate")
        }
    }

    let coordinator = TTSEmptyCoordinator()
    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

    return TTSThenValidateView(viewModel: viewModel)
}
