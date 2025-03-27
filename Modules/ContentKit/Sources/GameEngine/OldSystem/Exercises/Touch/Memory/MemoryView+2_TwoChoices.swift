// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension MemoryView {
    struct TwoChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: MemoryViewViewModel

        var body: some View {
            HStack(spacing: self.kHorizontalSpacing) {
                ForEach(self.viewModel.choices) { choice in
                    ZStack {
                        CardBackView(size: self.kAnswerSize, state: choice.state)
                        MemoryChoiceView(choice: choice, size: self.kAnswerSize)
                    }
                    .onTapGestureIf(choice.state == .idle) {
                        self.viewModel.onChoiceTapped(choice: choice)
                    }
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 40
        private let kAnswerSize: CGFloat = 300
    }
}

#Preview {
    let choices: [Memory.Choice] = [
        Memory.Choice(value: "red", type: .color, category: .catA),
        Memory.Choice(value: "red", type: .color, category: .catA),
    ]

    return MemoryView(choices: choices)
}
