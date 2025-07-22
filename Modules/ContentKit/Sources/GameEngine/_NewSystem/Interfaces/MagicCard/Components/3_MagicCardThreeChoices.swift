// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MagicCardView.ThreeChoicesView

extension MagicCardView {
    struct ThreeChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: MagicCardViewViewModel

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...1]) { choice in
                        Button {
                            self.viewModel.onTapped(cardID: choice.id)
                        } label: {
                            choice.view
                        }
                        .disabled(choice.disabled)
                    }
                }

                Button {
                    self.viewModel.onTapped(cardID: self.viewModel.choices[2].id)
                } label: {
                    self.viewModel.choices[2].view
                }
                .disabled(self.viewModel.choices[2].disabled)
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 80
        private let kVerticalSpacing: CGFloat = 40
    }
}

#if DEBUG
    #Preview {
        let coordinator = MagicCardEmptyCoordinator(choices: Array(MagicCardEmptyCoordinator.kDefaultChoices.prefix(3)))
        let viewModel = MagicCardViewViewModel(coordinator: coordinator)

        return MagicCardView(viewModel: viewModel)
    }
#endif
