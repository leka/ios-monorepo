// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct OneChoiceView: View {
    @ObservedObject private var viewModel: OneChoiceViewModel
    let horizontalSpacing: CGFloat = 32
    let answerSize: CGFloat = 300

    public init(gameplay: any GameplayProtocol) {
        self.viewModel = OneChoiceViewModel(gameplay: gameplay)
    }

    public var body: some View {
        HStack(spacing: horizontalSpacing) {
            let choice = viewModel.choices[0]

            ChoiceView(choice: choice, size: answerSize)
                .onTapGesture {
                    viewModel.onChoiceTapped(choice: choice)
                }
        }
    }
}
