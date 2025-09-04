// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MagicCardView.FourChoicesView

extension MagicCardView {
    struct FourChoicesView: View {
        @ObservedObject var viewModel: MagicCardViewViewModel

        var body: some View {
            VStack {
                HStack {
                    ForEach(self.viewModel.choices[0...1]) { choice in
                        Button {
                            self.viewModel.onTapped(cardID: choice.id)
                        } label: {
                            choice.view
                        }
                        .disabled(choice.disabled)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }

                HStack {
                    ForEach(self.viewModel.choices[2...3]) { choice in
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
}

#if DEBUG
    #Preview {
        let coordinator = MagicCardEmptyCoordinator(choices: Array(MagicCardEmptyCoordinator.kDefaultChoices.prefix(4)))
        let viewModel = MagicCardViewViewModel(coordinator: coordinator)

        return MagicCardView(viewModel: viewModel)
    }
#endif
