// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension RobotThenTouchToSelectInRightOrderView {
    struct OneChoiceView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectInRightOrderViewViewModel
        let isTappable: Bool

        var body: some View {
            let choice = self.viewModel.choices[0]
            TouchToSelectInRightOrderChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                .onTapGesture {
                    self.viewModel.onChoiceTapped(choice: choice)
                }
        }

        // MARK: Private

        private let kAnswerSize: CGFloat = 300
    }
}

#Preview {
    let choices: [TouchToSelectInRightOrder.Choice] = [
        TouchToSelectInRightOrder.Choice(value: "red", type: .color, order: 1),
    ]

    return RobotThenTouchToSelectInRightOrderView(choices: choices)
}
