// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension RobotThenTouchToSelectInRightOrderView {
    struct FourChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectInRightOrderViewViewModel
        let isTappable: Bool

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...1]) { choice in
                        TouchToSelectInRightOrderChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                            .onTapGesture {
                                self.viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[2...3]) { choice in
                        TouchToSelectInRightOrderChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                            .onTapGesture {
                                self.viewModel.onChoiceTapped(choice: choice)
                            }
                    }
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
    let choices: [TouchToSelectInRightOrder.Choice] = [
        TouchToSelectInRightOrder.Choice(value: "red", type: .color, order: 1),
        TouchToSelectInRightOrder.Choice(value: "blue", type: .color),
        TouchToSelectInRightOrder.Choice(value: "green", type: .color),
        TouchToSelectInRightOrder.Choice(value: "yellow", type: .color),
    ]

    return RobotThenTouchToSelectInRightOrderView(choices: choices)
}