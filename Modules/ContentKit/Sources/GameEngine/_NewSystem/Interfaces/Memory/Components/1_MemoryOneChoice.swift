// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewMemoryView.OneChoiceView

extension NewMemoryView {
    struct OneChoiceView: View {
        @ObservedObject var viewModel: NewMemoryViewViewModel

        var body: some View {
            let choice = self.viewModel.choices[0]
            choice.view
                .onTapGesture {
                    self.viewModel.onTapped(choice: choice)
                }
                .disabled(choice.disabled)
        }
    }
}
