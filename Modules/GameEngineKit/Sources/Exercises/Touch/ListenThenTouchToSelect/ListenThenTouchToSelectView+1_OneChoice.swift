// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ListenThenTouchToSelectView {
    struct OneChoiceView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectViewViewModel
        let isTappable: Bool

        var body: some View {
            let choice = self.viewModel.choices[0]
            TouchToSelectChoiceView(choice: choice.choice, state: choice.state, size: self.kAnswerSize, isTappable: self.isTappable)
                .onTapGesture {
                    self.viewModel.onChoiceTapped(choice: choice)
                }
        }

        // MARK: Private

        private let kAnswerSize: CGFloat = 300
    }
}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
    ]

    return ListenThenTouchToSelectView(
        choices: choices, audioRecording: AudioRecording(name: "drums", file: "drums")
    )
}
