// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension TTSView {
    struct TwoChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TTSViewViewModel

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
    // MARK: - TTSEmptyCoordinator

    class TTSEmptyCoordinator: TTSGameplayCoordinatorProtocol {
        var validationEnabled = CurrentValueSubject<Bool?, Never>(nil)

        func validateUserSelection() {
            log.debug("Choice validated")
        }

        var uiModel = CurrentValueSubject<TTSUIModel, Never>(TTSUIModel(action: nil, choices: [
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 2", type: .text,
                                                                                size: 240, state: .idle)),
        ]))

        func processUserSelection(choiceID: String) {
            log.debug("\(choiceID)")
        }
    }

    let coordinator = TTSEmptyCoordinator()
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
