// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension TouchToSelectView {

    struct ThreeChoicesView: View {

        @ObservedObject var viewModel: TouchToSelectViewViewModel

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
    var choices: [SelectionChoice] = [
        SelectionChoice(value: "red", type: .color, isRightAnswer: true),
        SelectionChoice(value: "blue", type: .color, isRightAnswer: false),
        SelectionChoice(value: "green", type: .color, isRightAnswer: false),
    ]

    let viewModel = TouchToSelectViewViewModel(choices: choices)

    return TouchToSelectView.ThreeChoicesView(viewModel: viewModel)
}
