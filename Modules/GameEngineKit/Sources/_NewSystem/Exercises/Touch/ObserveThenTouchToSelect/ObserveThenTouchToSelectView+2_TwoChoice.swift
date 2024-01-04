// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ObserveThenTouchToSelectView {
    struct TwoChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectViewViewModel
        let isTappable: Bool

        var body: some View {
            HStack(spacing: self.kHorizontalSpacing) {
                ForEach(self.viewModel.choices) { choice in
                    TouchToSelectChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                        .onTapGesture {
                            self.viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 60
        private let kAnswerSize: CGFloat = 180
    }
}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
        TouchToSelect.Choice(value: "blue", type: .color, isRightAnswer: false),
    ]

    return ObserveThenTouchToSelectView(choices: choices, image: "image-landscape-blue")
}
