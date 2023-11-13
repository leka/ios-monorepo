// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension TouchToSelectView {

    struct TwoChoicesView: View {

        @ObservedObject var viewModel: SelectionViewViewModel

        private let kHorizontalSpacing: CGFloat = 150
        private let kAnswerSize: CGFloat = 300

        var body: some View {
            HStack(spacing: kHorizontalSpacing) {
                ForEach(viewModel.choices) { choice in
                    SelectionChoiceView(choice: choice, size: kAnswerSize)
                        .onTapGesture {
                            viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
        }

    }

}

#Preview {
    let choices: [TouchSelectionChoice] = [
        TouchSelectionChoice(value: "red", type: .color, isRightAnswer: true),
        TouchSelectionChoice(value: "image-placeholder-food", type: .image, isRightAnswer: false),
    ]

    return TouchToSelectView(choices: choices)
}
