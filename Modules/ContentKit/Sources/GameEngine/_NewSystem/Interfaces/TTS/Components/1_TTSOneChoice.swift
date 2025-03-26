// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSView.OneChoiceView

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
            .disabled(choice.disabled)
        }
    }
}

#if DEBUG
    #Preview {
        let coordinator = TTSEmptyCoordinator(choices: Array(TTSEmptyCoordinator.kDefaultChoices.prefix(1)))
        let viewModel = TTSViewViewModel(coordinator: coordinator)

        return TTSView(viewModel: viewModel)
    }
#endif
