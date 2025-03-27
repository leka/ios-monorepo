// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension NewSuperSimonView {
    struct TwoChoicesView: View {
        // MARK: Internal

        var viewModel: NewSuperSimonViewViewModel

        var body: some View {
            HStack(spacing: self.kHorizontalSpacing) {
                ForEach(self.viewModel.choices) { choice in
                    Button {
                        self.viewModel.onTapped(choiceID: choice.id)
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

#Preview {
    let coordinator = NewSuperSimonCoordinator(level: .easy)
    let viewModel = NewSuperSimonViewViewModel(coordinator: coordinator)

    return NewSuperSimonView(viewModel: viewModel)
}
