// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ListenThenTouchToSelectView {

    struct OneChoiceView: View {

        @ObservedObject var viewModel: SelectionViewViewModel
        let isTappable: Bool

        private let kAnswerSize: CGFloat = 300

        var body: some View {
            let choice = viewModel.choices[0]
            SelectionChoiceView(choice: choice, size: kAnswerSize, isTappable: isTappable)
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

    let viewModel = SelectionViewViewModel(choices: choices)

    return TouchToSelectView.OneChoiceView(viewModel: viewModel)
}
