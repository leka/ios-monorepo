// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSView.TwoChoicesView

extension TTSView {
    struct TwoChoicesView: View {
        @ObservedObject var viewModel: TTSViewViewModel

        var body: some View {
            HStack {
                ForEach(self.viewModel.choices) { choice in
                    Button {
                        self.viewModel.onTapped(choice: choice)
                    } label: {
                        choice.view
                    }
                    .disabled(choice.disabled)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

#if DEBUG
    #Preview {
        let coordinator = TTSEmptyCoordinator(choices: Array(TTSEmptyCoordinator.kDefaultChoices.prefix(2)))
        let viewModel = TTSViewViewModel(coordinator: coordinator)

        return TTSView(viewModel: viewModel)
    }
#endif
