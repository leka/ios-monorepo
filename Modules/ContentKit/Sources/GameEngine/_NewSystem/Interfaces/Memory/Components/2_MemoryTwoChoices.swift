// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewMemoryView.TwoChoicesView

extension NewMemoryView {
    struct TwoChoicesView: View {
        @ObservedObject var viewModel: NewMemoryViewViewModel

        var body: some View {
            HStack {
                ForEach(self.viewModel.choices) { choice in
                    choice.view
                        .onTapGesture {
                            self.viewModel.onTapped(choice: choice)
                        }
                        .disabled(choice.disabled)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}
