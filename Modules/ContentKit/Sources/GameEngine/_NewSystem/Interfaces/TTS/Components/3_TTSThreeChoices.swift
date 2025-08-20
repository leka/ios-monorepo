// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSView.ThreeChoicesView

extension TTSView {
    struct ThreeChoicesView: View {
        @ObservedObject var viewModel: TTSViewViewModel

        var body: some View {
            VStack {
                HStack {
                    ForEach(self.viewModel.choices[0...1]) { choice in
                        Button {
                            self.viewModel.onTapped(choice: choice)
                        } label: {
                            choice.view
                        }
                        .disabled(choice.disabled)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }

                Button {
                    self.viewModel.onTapped(choice: self.viewModel.choices[2])
                } label: {
                    self.viewModel.choices[2].view
                }
                .disabled(self.viewModel.choices[2].disabled)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#if DEBUG
    #Preview {
        let coordinator = TTSEmptyCoordinator(choices: Array(TTSEmptyCoordinator.kDefaultChoices.prefix(3)))
        let viewModel = TTSViewViewModel(coordinator: coordinator)

        return TTSView(viewModel: viewModel)
    }
#endif
