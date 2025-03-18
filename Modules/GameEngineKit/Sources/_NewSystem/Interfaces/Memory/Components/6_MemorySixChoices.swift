// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - NewMemoryView.SixChoicesView

extension NewMemoryView {
    struct SixChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: NewMemoryViewViewModel

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...2]) { choice in
                        choice.view
                            .onTapGesture {
                                self.viewModel.onTapped(choice: choice)
                            }
                            .disabled(choice.disabled)
                    }
                }

                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[3...5]) { choice in
                        choice.view
                            .onTapGesture {
                                self.viewModel.onTapped(choice: choice)
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
