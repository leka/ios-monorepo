// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ListenThenTouchToSelectView {
    struct FourChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectViewViewModel
        let isTappable: Bool

        var body: some View {
            VStack(spacing: kVerticalSpacing) {
                HStack(spacing: kHorizontalSpacing) {
                    ForEach(viewModel.choices[0...1]) { choice in
                        TouchToSelectChoiceView(choice: choice, size: kAnswerSize, isTappable: isTappable)
                            .onTapGesture {
                                viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                HStack(spacing: kHorizontalSpacing) {
                    ForEach(viewModel.choices[2...3]) { choice in
                        TouchToSelectChoiceView(choice: choice, size: kAnswerSize, isTappable: isTappable)
                            .onTapGesture {
                                viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 200
        private let kVerticalSpacing: CGFloat = 40
        private let kAnswerSize: CGFloat = 240
    }
}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
        TouchToSelect.Choice(value: "blue", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "green", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "yellow", type: .color, isRightAnswer: false),
    ]

    return ListenThenTouchToSelectView(
        choices: choices, audioRecording: AudioRecording(name: "drums", file: "drums")
    )
}
