// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - NewMemoryView.TwoChoicesView

extension NewMemoryView {
    struct TwoChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: NewMemoryViewViewModel

        var body: some View {
            HStack(spacing: self.kHorizontalSpacing) {
                ForEach(self.viewModel.choices) { choice in
                    choice.view
                        .onTapGesture {
                            self.viewModel.onTapped(choice: choice)
                        }
                        .disabled(choice.disabled)
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 150
    }
}
