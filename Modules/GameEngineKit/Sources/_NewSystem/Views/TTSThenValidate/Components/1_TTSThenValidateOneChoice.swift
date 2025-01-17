// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

extension TTSThenValidateView {
    struct OneChoiceView: View {
        @ObservedObject var viewModel: TTSThenValidateViewViewModel

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
    // MARK: - TTSThenValidateEmptyCoordinator

    class TTSThenValidateEmptyCoordinator: TTSThenValidateGameplayCoordinatorProtocol {
        var uiModel = CurrentValueSubject<TTSUIModel, Never>(TTSUIModel(action: nil, choices: [
            TTSUIChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
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
