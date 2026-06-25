// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MagicCardView.TwoChoicesView

extension MagicCardView {
    struct TwoChoicesView: View {
        @ObservedObject var viewModel: MagicCardViewViewModel

        var body: some View {
            HStack {
                ForEach(self.viewModel.choices) { choice in
                    Button {
                        self.viewModel.onTapped(cardID: choice.id)
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
        let coordinator = MagicCardEmptyCoordinator(choices: Array(MagicCardEmptyCoordinator.kDefaultChoices.prefix(2)))
        let viewModel = MagicCardViewViewModel(coordinator: coordinator)

        return MagicCardView(viewModel: viewModel)
    }
#endif
