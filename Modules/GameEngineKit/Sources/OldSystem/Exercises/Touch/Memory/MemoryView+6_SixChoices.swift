// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension MemoryView {
    struct SixChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: MemoryViewViewModel

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...2]) { choice in
                        ZStack {
                            CardBackView(size: self.kAnswerSize, state: choice.state)
                            MemoryChoiceView(choice: choice, size: self.kAnswerSize)
                        }
                        .onTapGestureIf(choice.state == .idle) {
                            self.viewModel.onChoiceTapped(choice: choice)
                        }
                    }
                }

                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[3...5]) { choice in
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
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 25
        private let kVerticalSpacing: CGFloat = 25
        private let kAnswerSize: CGFloat = 268
    }
}

#Preview {
    let choices: [Memory.Choice] = [
        Memory.Choice(value: "red", type: .color, category: .catA),
        Memory.Choice(value: "yellow", type: .color, category: .catB),
        Memory.Choice(value: "green", type: .color, category: .catC),
        Memory.Choice(value: "green", type: .color, category: .catC),
        Memory.Choice(value: "yellow", type: .color, category: .catB),
        Memory.Choice(value: "red", type: .color, category: .catA),
    ]

    return MemoryView(choices: choices)
}
