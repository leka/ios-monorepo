// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ListenThenTouchToSelectView {

    struct FiveChoicesView: View {

        @ObservedObject var viewModel: SelectionViewViewModel
        let isTappable: Bool

        private let kHorizontalSpacing: CGFloat = 60
        private let kVerticalSpacing: CGFloat = 40
        private let kAnswerSize: CGFloat = 200

        var body: some View {
            VStack(spacing: kVerticalSpacing) {
                HStack(spacing: kHorizontalSpacing) {
                    ForEach(viewModel.choices[0...2]) { choice in
                        SelectionChoiceView(choice: choice, size: kAnswerSize, isTappable: isTappable)
                            .onTapGesture {
                                viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                HStack(spacing: kHorizontalSpacing) {
                    ForEach(viewModel.choices[3...4]) { choice in
                        SelectionChoiceView(choice: choice, size: kAnswerSize, isTappable: isTappable)
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
    let choices: [SelectionChoice] = [
        SelectionChoice(value: "red", type: .color, isRightAnswer: true),
        SelectionChoice(value: "blue", type: .color, isRightAnswer: false),
        SelectionChoice(value: "green", type: .color, isRightAnswer: false),
        SelectionChoice(value: "yellow", type: .color, isRightAnswer: false),
        SelectionChoice(value: "purple", type: .color, isRightAnswer: false),
    ]

    return ListenThenTouchToSelectView(
        choices: choices, audioRecording: AudioRecordingModel(name: "drums", file: "drums"))
}
