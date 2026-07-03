// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension NewSuperSimonView {
    struct SixChoicesView: View {
        var viewModel: NewSuperSimonViewViewModel

        var body: some View {
            VStack {
                HStack {
                    ForEach(self.viewModel.choices[0...2]) { choice in
                        Button {
                            self.viewModel.onTapped(choiceID: choice.id)
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
                            self.viewModel.onTapped(choiceID: choice.id)
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

#Preview {
    let coordinator = NewSuperSimonCoordinator(level: .hard)
    let viewModel = NewSuperSimonViewViewModel(coordinator: coordinator)

    return NewSuperSimonView(viewModel: viewModel)
}
