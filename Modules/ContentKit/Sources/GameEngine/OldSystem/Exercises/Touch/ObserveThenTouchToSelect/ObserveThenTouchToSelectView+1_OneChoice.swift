// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension ObserveThenTouchToSelectView {
    struct OneChoiceView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectViewViewModel

        let isTappable: Bool

        var body: some View {
            let choice = self.viewModel.choices[0]
            TouchToSelectChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                .onTapGesture {
                    self.viewModel.onChoiceTapped(choice: choice)
                }
        }

        // MARK: Private

        private let kAnswerSize: CGFloat = 180
    }
}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
    ]

    return ObserveThenTouchToSelectView(choices: choices, image: "image-landscape-blue")
}
