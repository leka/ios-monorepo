// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension TTSView {
    struct OneChoiceView: View {
        @ObservedObject var viewModel: TTSViewViewModel

        var body: some View {
            let choice = self.viewModel.choices[0]
            Button {
                self.viewModel.onTapped(choice: choice)
            } label: {
                choice.view
            }
        }
    }
}

#Preview {
    // MARK: - TTSEmptyCoordinator

    class TTSEmptyCoordinator: TTSGameplayCoordinatorProtocol {
        var uiModel = CurrentValueSubject<TTSUIModel, Never>(TTSUIModel(action: nil, choices: [
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
        ]))

        func processUserSelection(choiceID: String) {
            log.debug("\(choiceID)")
        }
    }

    let coordinator = TTSEmptyCoordinator()
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
