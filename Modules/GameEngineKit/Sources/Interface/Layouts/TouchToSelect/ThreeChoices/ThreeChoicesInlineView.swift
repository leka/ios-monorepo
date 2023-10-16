// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ThreeChoicesInlineView: View {
    @StateObject private var viewModel: GenericViewModel
    let horizontalSpacing: CGFloat = 60
    let answerSize: CGFloat = 300

    public init(gameplay: any GameplayProtocol<ChoiceModel>) {
        self._viewModel = StateObject(wrappedValue: GenericViewModel(gameplay: gameplay))
    }

    public var body: some View {
        HStack(spacing: horizontalSpacing) {
            ForEach(0..<3) { index in
                let choice = viewModel.choices[index]

                ChoiceView(choice: choice, size: answerSize)
                    .onTapGesture {
                        viewModel.onChoiceTapped(choice: choice)
                    }
            }
        }
    }
}
