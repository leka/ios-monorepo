// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension ObserveThenTouchToSelectView {
    struct FiveChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectViewViewModel

        let isTappable: Bool

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...2]) { choice in
                        TouchToSelectChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                            .onTapGesture {
                                self.viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[3...4]) { choice in
                        TouchToSelectChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                            .onTapGesture {
                                self.viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 40
        private let kVerticalSpacing: CGFloat = 40
        private let kAnswerSize: CGFloat = 140
    }
}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
        TouchToSelect.Choice(value: "blue", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "green", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "yellow", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "purple", type: .color, isRightAnswer: false),
    ]

    return ObserveThenTouchToSelectView(choices: choices, image: "image-landscape-blue")
}
