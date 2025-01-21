// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSView.SixChoicesView

extension TTSView {
    struct SixChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TTSViewViewModel

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...2]) { choice in
                        Button {
                            self.viewModel.onTapped(choice: choice)
                        } label: {
                            choice.view
                        }
                        .disabled(choice.disabled)
                    }
                }

                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[3...5]) { choice in
                        Button {
                            self.viewModel.onTapped(choice: choice)
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

#if DEBUG
    #Preview {
        let coordinator = TTSEmptyCoordinator(choices: Array(TTSEmptyCoordinator.kDefaultChoices.prefix(6)))
        let viewModel = TTSViewViewModel(coordinator: coordinator)

        return TTSView(viewModel: viewModel)
    }
#endif
