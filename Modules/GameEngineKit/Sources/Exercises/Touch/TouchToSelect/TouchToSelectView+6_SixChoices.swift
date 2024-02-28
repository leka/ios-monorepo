// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension TouchToSelectView {
    struct SixChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: TouchToSelectViewViewModel

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...2]) { choice in
                        TouchToSelectChoiceView(choice: choice, size: self.kAnswerSize)
                            .onTapGesture {
                                self.viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[3...5]) { choice in
                        TouchToSelectChoiceView(choice: choice, size: self.kAnswerSize)
                            .onTapGesture {
                                self.viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }
            }
        }

        // MARK: Private

        private let kHorizontalSpacing: CGFloat = 60
        private let kVerticalSpacing: CGFloat = 40
        private let kAnswerSize: CGFloat = 240
    }
}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: true),
        TouchToSelect.Choice(value: "blue", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "green", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "image-placeholder-animals", type: .image, isRightAnswer: false),
        TouchToSelect.Choice(value: "image-placeholder-food", type: .image, isRightAnswer: false),
        TouchToSelect.Choice(value: "image-placeholder-portrait", type: .image, isRightAnswer: false),
    ]

    return TouchToSelectView(choices: choices)
}