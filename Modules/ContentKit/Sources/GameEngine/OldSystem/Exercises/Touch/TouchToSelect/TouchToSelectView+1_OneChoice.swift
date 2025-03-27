// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension TouchToSelectView {
    struct OneChoiceView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectViewViewModel

        var body: some View {
            let choice = self.viewModel.choices[0]
            TouchToSelectChoiceView(choice: choice, size: self.kAnswerSize)
                .onTapGesture {
                    self.viewModel.onChoiceTapped(choice: choice)
                }
        }

        // MARK: Private

        private let kAnswerSize: CGFloat = 300
    }
}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
    ]

    return TouchToSelectView(choices: choices)
}
