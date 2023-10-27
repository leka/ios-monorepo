// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ObserveThenTouchToSelectView {

    struct TwoChoicesView: View {

        @ObservedObject var viewModel: SelectionViewViewModel
        let isTappable: Bool

        private let kHorizontalSpacing: CGFloat = 150
        private let kAnswerSize: CGFloat = 300

        var body: some View {
            HStack(spacing: kHorizontalSpacing) {
                ForEach(viewModel.choices) { choice in
                    SelectionChoiceView(choice: choice, size: kAnswerSize, isTappable: isTappable)
                        .onTapGesture {
                            viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
        }

    }

}

#Preview {
    let choices: [SelectionChoice] = [
        SelectionChoice(value: "red", type: .color, isRightAnswer: true),
        SelectionChoice(value: "blue", type: .color, isRightAnswer: false),
    ]

    return ObserveThenTouchToSelectView(choices: choices, image: "image-landscape-blue")
}
