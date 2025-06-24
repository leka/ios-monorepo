// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension SuperSimonView {
    struct TwoChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: SuperSimonViewViewModel

        let isTappable: Bool

        var body: some View {
            HStack(spacing: self.kHorizontalSpacing) {
                ForEach(self.viewModel.choices) { choice in
                    SuperSimonChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                        .onTapGesture {
                            self.viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 150
        private let kAnswerSize: CGFloat = 300
    }
}

#Preview {
    SuperSimonView(level: .easy)
}
