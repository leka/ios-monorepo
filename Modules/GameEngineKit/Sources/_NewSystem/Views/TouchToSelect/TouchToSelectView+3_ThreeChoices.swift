// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension TouchToSelectView {

    struct ThreeChoicesView: View {

        @ObservedObject var viewModel: SelectionViewViewModel

        private let kHorizontalSpacing: CGFloat = 80
        private let kAnswerSize: CGFloat = 280

        var body: some View {
            HStack(spacing: kHorizontalSpacing) {
                ForEach(viewModel.choices[0...2]) { choice in
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
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
        TouchToSelect.Choice(value: "image-placeholder-food", type: .image, isRightAnswer: false),
        TouchToSelect.Choice(value: "image-placeholder-portrait", type: .image, isRightAnswer: false),
    ]

    return TouchToSelectView(choices: choices)
}
