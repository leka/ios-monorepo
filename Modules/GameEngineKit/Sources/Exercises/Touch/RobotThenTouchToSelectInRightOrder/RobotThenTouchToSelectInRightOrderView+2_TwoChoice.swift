// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension RobotThenTouchToSelectInRightOrderView {
    struct TwoChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectInRightOrderViewViewModel
        let isTappable: Bool

        var body: some View {
            HStack(spacing: self.kHorizontalSpacing) {
                ForEach(self.viewModel.choices) { choice in
                    TouchToSelectInRightOrderChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                        .onTapGesture {
                            self.viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 100
        private let kAnswerSize: CGFloat = 300
    }
}

#Preview {
    let choices: [TouchToSelectInRightOrder.Choice] = [
        TouchToSelectInRightOrder.Choice(value: "red", type: .color, order: 1),
        TouchToSelectInRightOrder.Choice(value: "blue", type: .color),
    ]

    return RobotThenTouchToSelectInRightOrderView(choices: choices)
}
