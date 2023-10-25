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
            ChoiceView(choice: choice.choice, state: choice.state, size: kAnswerSize)
                .onTapGesture {
                    viewModel.onChoiceTapped(choice: choice)
                }
        }

    }

}

#Preview {
    var choices: [SelectionChoice] = [
        SelectionChoice(value: "red", type: .color, isRightAnswer: true)
    ]

    let viewModel = TouchToSelectViewViewModel(choices: choices)

    return TouchToSelectView.OneChoiceView(viewModel: viewModel)
}
