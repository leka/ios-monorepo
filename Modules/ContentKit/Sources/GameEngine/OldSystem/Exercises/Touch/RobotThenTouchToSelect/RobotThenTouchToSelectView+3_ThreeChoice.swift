// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension RobotThenTouchToSelectView {
    struct ThreeChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectViewViewModel

        let isTappable: Bool

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...1]) { choice in
                        TouchToSelectChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                            .onTapGesture {
                                self.viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                TouchToSelectChoiceView(choice: self.viewModel.choices[2], size: self.kAnswerSize, isTappable: self.isTappable)
                    .onTapGesture {
                        self.viewModel.onChoiceTapped(choice: self.viewModel.choices[2])
                    }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 200
        private let kVerticalSpacing: CGFloat = 40
        private let kAnswerSize: CGFloat = 240
    }
}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
        TouchToSelect.Choice(value: "blue", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "green", type: .color, isRightAnswer: false),
    ]

    return RobotThenTouchToSelectView(choices: choices)
}
