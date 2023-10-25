// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension TouchToSelectView {

    struct FourChoicesView: View {

        @ObservedObject var viewModel: TouchToSelectViewViewModel

        private let kHorizontalSpacing: CGFloat = 200
        private let kVerticalSpacing: CGFloat = 40
        private let kAnswerSize: CGFloat = 240

        var body: some View {
            VStack(spacing: kVerticalSpacing) {
                HStack(spacing: kHorizontalSpacing) {
                    ForEach(viewModel.choices[0...1]) { choice in
                        SelectionChoiceView(choice: choice.choice, state: choice.state, size: kAnswerSize)
                            .onTapGesture {
                                viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                HStack(spacing: kHorizontalSpacing) {
                    ForEach(viewModel.choices[2...3]) { choice in
                        SelectionChoiceView(choice: choice.choice, state: choice.state, size: kAnswerSize)
                            .onTapGesture {
                                viewModel.onChoiceTapped(choice: choice)
                            }
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
        SelectionChoice(value: "green", type: .color, isRightAnswer: false),
        SelectionChoice(value: "yellow", type: .color, isRightAnswer: false),
    ]

    let viewModel = TouchToSelectViewViewModel(choices: choices)

    return TouchToSelectView.FourChoicesView(viewModel: viewModel)
}
