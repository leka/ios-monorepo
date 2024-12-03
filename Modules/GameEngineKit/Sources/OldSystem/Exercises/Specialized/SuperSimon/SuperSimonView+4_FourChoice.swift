// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension SuperSimonView {
    struct FourChoicesView: View {
        // MARK: Internal

        @ObservedObject var viewModel: SuperSimonViewViewModel

        let isTappable: Bool

        var body: some View {
            VStack(spacing: self.kVerticalSpacing) {
                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[0...1]) { choice in
                        SuperSimonChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                            .onTapGesture {
                                self.viewModel.onChoiceTapped(choice: choice)
                            }
                    }
                }

                HStack(spacing: self.kHorizontalSpacing) {
                    ForEach(self.viewModel.choices[2...3]) { choice in
                        SuperSimonChoiceView(choice: choice, size: self.kAnswerSize, isTappable: self.isTappable)
                            .onTapGesture {
                                self.viewModel.onChoiceTapped(choice: choice)
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
    SuperSimonView(level: .medium)
}
