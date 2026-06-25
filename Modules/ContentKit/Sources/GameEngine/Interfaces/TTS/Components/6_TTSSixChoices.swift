// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSView.SixChoicesView

extension TTSView {
    struct SixChoicesView: View {
        @ObservedObject var viewModel: TTSViewViewModel

        var body: some View {
            VStack {
                HStack {
                    ForEach(self.viewModel.choices[0...2]) { choice in
                        Button {
                            self.viewModel.onTapped(choice: choice)
                        } label: {
                            choice.view
                        }
                        .disabled(choice.disabled)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }

                HStack {
                    ForEach(self.viewModel.choices[3...5]) { choice in
                        Button {
                            self.viewModel.onTapped(choice: choice)
                        } label: {
                            choice.view
                        }
                        .disabled(choice.disabled)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
    }
}

#if DEBUG
    #Preview {
        let coordinator = TTSEmptyCoordinator(choices: Array(TTSEmptyCoordinator.kDefaultChoices.prefix(6)))
        let viewModel = TTSViewViewModel(coordinator: coordinator)

        return TTSView(viewModel: viewModel)
    }
#endif
