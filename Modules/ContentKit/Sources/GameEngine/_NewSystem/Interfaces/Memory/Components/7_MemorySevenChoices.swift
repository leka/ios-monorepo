// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewMemoryView.SevenChoicesView

extension NewMemoryView {
    struct SevenChoicesView: View {
        @ObservedObject var viewModel: NewMemoryViewViewModel

        var body: some View {
            VStack {
                HStack {
                    ForEach(self.viewModel.choices[0...3]) { choice in
                        choice.view
                            .onTapGesture {
                                self.viewModel.onTapped(choice: choice)
                            }
                            .disabled(choice.disabled)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }

                HStack {
                    ForEach(self.viewModel.choices[4...6]) { choice in
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
}
