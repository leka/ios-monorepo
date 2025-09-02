// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewMemoryView.ThreeChoicesView

extension NewMemoryView {
    struct ThreeChoicesView: View {
        @ObservedObject var viewModel: NewMemoryViewViewModel

        var body: some View {
            VStack {
                HStack {
                    ForEach(self.viewModel.choices[0...1]) { choice in
                        choice.view
                            .onTapGesture {
                                self.viewModel.onTapped(choice: choice)
                            }
                            .disabled(choice.disabled)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }

                self.viewModel.choices[2].view
                    .onTapGesture {
                        self.viewModel.onTapped(choice: self.viewModel.choices[2])
                    }
                    .disabled(self.viewModel.choices[2].disabled)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
