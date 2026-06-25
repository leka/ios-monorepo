// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MagicCardView.OneChoiceView

extension MagicCardView {
    struct OneChoiceView: View {
        @ObservedObject var viewModel: MagicCardViewViewModel

        var body: some View {
            let choice = self.viewModel.choices[0]
            Button {
                self.viewModel.onTapped(cardID: choice.id)
            } label: {
                choice.view
            }
            .disabled(choice.disabled)
        }
    }
}

#if DEBUG
    #Preview {
        let coordinator = MagicCardEmptyCoordinator(choices: Array(MagicCardEmptyCoordinator.kDefaultChoices.prefix(1)))
        let viewModel = MagicCardViewViewModel(coordinator: coordinator)

        return MagicCardView(viewModel: viewModel)
    }
#endif
