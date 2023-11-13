// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension TouchToSelectView {

    struct FiveChoicesView: View {

        @ObservedObject var viewModel: SelectionViewViewModel

        private let kHorizontalSpacing: CGFloat = 60
        private let kVerticalSpacing: CGFloat = 40
        private let kAnswerSize: CGFloat = 240

        var body: some View {
            VStack(spacing: kVerticalSpacing) {
                HStack(spacing: kHorizontalSpacing) {
                    ForEach(viewModel.choices[0...2]) { choice in
                        SelectionChoiceView(choice: choice, size: kAnswerSize)
                            .onTapGesture {
                                viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                HStack(spacing: kHorizontalSpacing) {
                    ForEach(viewModel.choices[3...4]) { choice in
                        SelectionChoiceView(choice: choice, size: kAnswerSize)
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
    let choices: [TouchSelection.Choice] = [
        TouchSelection.Choice(value: "red", type: .color, isRightAnswer: true),
        TouchSelection.Choice(value: "blue", type: .color, isRightAnswer: false),
        TouchSelection.Choice(value: "green", type: .color, isRightAnswer: false),
        TouchSelection.Choice(value: "image-placeholder-food", type: .image, isRightAnswer: false),
        TouchSelection.Choice(value: "image-placeholder-portrait", type: .image, isRightAnswer: false),
    ]

    return TouchToSelectView(choices: choices)
}
