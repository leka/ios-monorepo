// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension TouchToSelectView {
    struct TwoChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectViewViewModel

        var body: some View {
            HStack(spacing: self.kHorizontalSpacing) {
                ForEach(self.viewModel.choices) { choice in
                    TouchToSelectChoiceView(choice: choice, size: self.kAnswerSize)
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
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
        TouchToSelect.Choice(value: "image-placeholder-food", type: .image, isRightAnswer: false),
    ]

    return TouchToSelectView(choices: choices)
}
