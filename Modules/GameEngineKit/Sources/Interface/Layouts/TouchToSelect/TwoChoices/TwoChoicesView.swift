// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct TwoChoicesView: View {
    @ObservedObject private var viewModel: GenericViewModel
    let horizontalSpacing: CGFloat = 150
    let answerSize: CGFloat = 300

    public init(gameplay: any GameplayProtocol) {
        self.viewModel = GenericViewModel(gameplay: gameplay)
    }

    public var body: some View {
        HStack(spacing: horizontalSpacing) {
            ForEach(0..<2) { index in
                let choice = viewModel.choices[index]

                ChoiceView(choice: choice, size: answerSize)
                    .onTapGesture {
                        viewModel.onChoiceTapped(choice: choice)
                    }
            }
        }
    }
}
