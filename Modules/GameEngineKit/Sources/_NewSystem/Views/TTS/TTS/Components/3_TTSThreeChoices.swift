// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension TTSView {
    struct ThreeChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TTSViewViewModel

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...1]) { choice in
                        Button {
                            self.viewModel.onTapped(choice: choice)
                        } label: {
                            choice.view
                        }
                    }
                }

                Button {
                    self.viewModel.onTapped(choice: self.viewModel.choices[2])
                } label: {
                    self.viewModel.choices[2].view
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 80
        private let kVerticalSpacing: CGFloat = 40
    }
}

#Preview {
    // MARK: - TTSEmptyCoordinator

    class TTSEmptyCoordinator: TTSGameplayCoordinatorProtocol {
        var uiModel = CurrentValueSubject<TTSUIModel, Never>(TTSUIModel(action: nil, choices: [
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 2", type: .text,
                                                                                size: 240, state: .idle)),
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 3\nCorrect", type: .text,
                                                                                size: 240, state: .correct)),
        ]))

        func processUserSelection(choice: TTSUIChoiceModel) {
            log.debug("\(choice.id)")
        }
    }

    let coordinator = TTSEmptyCoordinator()
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
