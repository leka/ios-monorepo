// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension NewSuperSimonView {
    struct SixChoicesView: View {
        // MARK: Internal

        var viewModel: NewSuperSimonViewViewModel

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...2]) { choice in
                        Button {
                            self.viewModel.onTapped(choiceID: choice.id)
                        } label: {
                            choice.view
                        }
                        .disabled(choice.disabled)
                    }
                }

                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[3...5]) { choice in
                        Button {
                            self.viewModel.onTapped(choiceID: choice.id)
                        } label: {
                            choice.view
                        }
                        .disabled(choice.disabled)
                    }
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 60
        private let kVerticalSpacing: CGFloat = 40
    }
}

#Preview {
    let coordinator = NewSuperSimonCoordinator(level: .hard)
    let viewModel = NewSuperSimonViewViewModel(coordinator: coordinator)

    return NewSuperSimonView(viewModel: viewModel)
}
