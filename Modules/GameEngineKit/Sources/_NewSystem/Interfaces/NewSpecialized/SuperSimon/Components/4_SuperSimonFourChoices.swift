// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension NewSuperSimonView {
    struct FourChoicesView: View {
        // MARK: Internal

        var viewModel: NewSuperSimonViewViewModel

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...1]) { choice in
                        Button {
                            self.viewModel.onTapped(choiceID: choice.id)
                        } label: {
                            choice.view
                        }
                        .disabled(choice.disabled)
                    }
                }

                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[2...3]) { choice in
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

        private let kHorizontalSpacing: CGFloat = 160
        private let kVerticalSpacing: CGFloat = 40
    }
}

#Preview {
    let coordinator = NewSuperSimonCoordinator(level: .medium)
    let viewModel = NewSuperSimonViewViewModel(coordinator: coordinator)

    return NewSuperSimonView(viewModel: viewModel)
}
