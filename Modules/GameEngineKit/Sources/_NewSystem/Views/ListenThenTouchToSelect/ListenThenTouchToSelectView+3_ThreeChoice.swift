// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ListenThenTouchToSelectView {

    struct ThreeChoicesView: View {

        @ObservedObject var viewModel: SelectionViewViewModel
        let isTappable: Bool

        private let kHorizontalSpacing: CGFloat = 200
        private let kVerticalSpacing: CGFloat = 40
        private let kAnswerSize: CGFloat = 240

        var body: some View {
            VStack(spacing: kVerticalSpacing) {
                HStack(spacing: kHorizontalSpacing) {
                    ForEach(viewModel.choices[0...1]) { choice in
                        SelectionChoiceView(choice: choice, size: kAnswerSize, isTappable: isTappable)
                            .onTapGesture {
                                viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                SelectionChoiceView(choice: viewModel.choices[2], size: kAnswerSize, isTappable: isTappable)
                    .onTapGesture {
                        viewModel.onChoiceTapped(choice: viewModel.choices[2])
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
    ]

    return ListenThenTouchToSelectView(
        choices: choices, audioRecording: AudioRecordingModel(name: "drums", file: "drums"))
}
