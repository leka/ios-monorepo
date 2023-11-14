// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ObserveThenTouchToSelectView {

    struct OneChoiceView: View {

        @ObservedObject var viewModel: TouchToSelectViewViewModel
        let isTappable: Bool

        private let kAnswerSize: CGFloat = 180

        var body: some View {
            let choice = viewModel.choices[0]
            TouchToSelectChoiceView(choice: choice, size: kAnswerSize, isTappable: isTappable)
                .onTapGesture {
                    viewModel.onChoiceTapped(choice: choice)
                }
        }

    }

}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true)
    ]

    return ObserveThenTouchToSelectView(choices: choices, image: "image-landscape-blue")
}
