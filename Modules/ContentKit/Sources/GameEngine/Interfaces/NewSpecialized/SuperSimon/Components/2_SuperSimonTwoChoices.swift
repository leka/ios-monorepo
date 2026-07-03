// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension NewSuperSimonView {
    struct TwoChoicesView: View {
        var viewModel: NewSuperSimonViewViewModel

        var body: some View {
            HStack {
                ForEach(self.viewModel.choices) { choice in
                    Button {
                        self.viewModel.onTapped(choiceID: choice.id)
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

#Preview {
    let coordinator = NewSuperSimonCoordinator(level: .easy)
    let viewModel = NewSuperSimonViewViewModel(coordinator: coordinator)

    return NewSuperSimonView(viewModel: viewModel)
}
