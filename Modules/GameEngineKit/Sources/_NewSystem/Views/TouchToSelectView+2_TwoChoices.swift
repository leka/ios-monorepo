// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension TouchToSelectView {

    struct TwoChoicesView: View {

        @ObservedObject var viewModel: TouchToSelectViewViewModel

        private let kHorizontalSpacing: CGFloat = 150
        private let kAnswerSize: CGFloat = 300

        var body: some View {
            HStack(spacing: kHorizontalSpacing) {
                ForEach(viewModel.choices) { choice in
                    SelectionChoiceView(choice: choice.choice, state: choice.state, size: kAnswerSize)
                        .onTapGesture {
                            viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
        }

    }

}

#Preview {
    var choices: [SelectionChoice] = [
        SelectionChoice(value: "red", type: .color, isRightAnswer: true),
        SelectionChoice(value: "blue", type: .color, isRightAnswer: false),
    ]

    let viewModel = TouchToSelectViewViewModel(choices: choices)

    return TouchToSelectView.TwoChoicesView(viewModel: viewModel)
}
