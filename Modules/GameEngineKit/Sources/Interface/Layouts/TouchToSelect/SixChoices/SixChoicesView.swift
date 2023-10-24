// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct SixChoicesView: View {
    @StateObject private var viewModel: GenericViewModel
    let horizontalSpacing: CGFloat = 100
    let verticalSpacing: CGFloat = 32
    let answerSize: CGFloat = 250

    public init(gameplay: any SelectionGameplayProtocol) {
        self._viewModel = StateObject(wrappedValue: GenericViewModel(gameplay: gameplay))
    }

    public var body: some View {
        Grid(
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        ) {
            GridRow {
                ForEach(0..<3) { index in
                    let choice = viewModel.choices[index]

                    ChoiceViewDeprecated(choice: choice, size: answerSize)
                        .onTapGesture {
                            viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
            GridRow {
                ForEach(3..<6) { index in
                    let choice = viewModel.choices[index]

                    ChoiceViewDeprecated(choice: choice, size: answerSize)
                        .onTapGesture {
                            viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
        }
    }
}
