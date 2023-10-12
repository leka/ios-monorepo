// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct FourChoicesView: View {
    @StateObject private var viewModel: GenericViewModel
    let horizontalSpacing: CGFloat = 200
    let verticalSpacing: CGFloat = 40
    let answerSize: CGFloat = 240

    public init(gameplay: any SelectionGameplayProtocol) {
        self._viewModel = StateObject(wrappedValue: GenericViewModel(gameplay: gameplay))
    }

    public var body: some View {
        Grid(
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        ) {
            GridRow {
                ForEach(0..<2) { index in
                    let choice = viewModel.choices[index]

                    ChoiceView(choice: choice, size: answerSize)
                        .onTapGesture {
                            viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
            GridRow {
                ForEach(2..<4) { index in
                    let choice = viewModel.choices[index]

                    ChoiceView(choice: choice, size: answerSize)
                        .onTapGesture {
                            viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
        }
    }
}
