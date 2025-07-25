// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MagicCardView.TwoChoicesView

extension MagicCardView {
    struct TwoChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: MagicCardViewViewModel

        var body: some View {
            HStack(spacing: self.kHorizontalSpacing) {
                ForEach(self.viewModel.choices) { choice in
                    Button {
                        self.viewModel.onTapped(cardID: choice.id)
                    } label: {
                        choice.view
                    }
                    .disabled(choice.disabled)
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 150
    }
}

#if DEBUG
    #Preview {
        let coordinator = MagicCardEmptyCoordinator(choices: Array(MagicCardEmptyCoordinator.kDefaultChoices.prefix(2)))
        let viewModel = MagicCardViewViewModel(coordinator: coordinator)

        return MagicCardView(viewModel: viewModel)
    }
#endif
