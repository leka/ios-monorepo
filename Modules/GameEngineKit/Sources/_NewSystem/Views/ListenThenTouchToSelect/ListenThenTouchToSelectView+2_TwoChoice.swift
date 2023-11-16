// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ListenThenTouchToSelectView {

    struct TwoChoicesView: View {

        @ObservedObject var viewModel: TouchToSelectViewViewModel
        let isTappable: Bool

        private let kHorizontalSpacing: CGFloat = 100
        private let kAnswerSize: CGFloat = 300

        var body: some View {
            HStack(spacing: kHorizontalSpacing) {
                ForEach(viewModel.choices) { choice in
                    TouchToSelectChoiceView(choice: choice, size: kAnswerSize, isTappable: isTappable)
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
        TouchToSelect.Choice(value: "blue", type: .color, isRightAnswer: false),
    ]

    return ListenThenTouchToSelectView(
        choices: choices, audioRecording: AudioRecording(name: "drums", file: "drums"))
}
