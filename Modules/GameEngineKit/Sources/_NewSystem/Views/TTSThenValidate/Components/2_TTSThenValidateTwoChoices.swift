// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension TTSThenValidateView {
    struct TwoChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TTSThenValidateViewViewModel

        var body: some View {
            HStack(spacing: self.kHorizontalSpacing) {
                ForEach(self.viewModel.choices) { choice in
                    Button {
                        self.viewModel.onTapped(choice: choice)
                    } label: {
                        choice.view
                    }
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 150
    }
}

#Preview {
    // MARK: - TTSThenValidateEmptyCoordinator

    class TTSThenValidateEmptyCoordinator: TTSThenValidateGameplayCoordinatorProtocol {
        var uiModel = CurrentValueSubject<TTSUIModel, Never>(TTSUIModel(action: nil, choices: [
            TTSUIChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
            TTSUIChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 2", type: .text,
                                                                                            size: 240, state: .idle)),
        ]))
        public private(set) var validationEnabled = CurrentValueSubject<Bool, Never>(false)

        func processUserSelection(choice: TTSUIChoiceModel) {
            log.debug("\(choice.id)")
            self.validationEnabled.send(true)
        }

        func validateUserSelection() {
            log.debug("Validate")
            self.validationEnabled.send(false)
        }
    }

    let coordinator = TTSThenValidateEmptyCoordinator()
    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

    return TTSThenValidateView(viewModel: viewModel)
}
