// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension TouchToSelectView {

    struct OneChoiceView: View {

        @ObservedObject var viewModel: TouchToSelectViewViewModel

        private let kAnswerSize: CGFloat = 300

        var body: some View {
            let choice = viewModel.choices[0]
            SelectionChoiceView(choice: choice, size: kAnswerSize)
                .onTapGesture {
                    viewModel.onChoiceTapped(choice: choice)
                }
        }
    }

}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true)
    ]

    return TouchToSelectView(choices: choices)
}
