// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct SixChoicesView: View {
    @ObservedObject private var viewModel: SixChoicesViewModel
	let horizontalSpacing: CGFloat = 100
	let verticalSpacing: CGFloat = 32
	let answerSize: CGFloat = 300

    public init(gameplay: any GameplayProtocol) {
        self.viewModel = SixChoicesViewModel(gameplay: gameplay)
    }

    public var body: some View {
        Grid(
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        ) {
            GridRow {
                ForEach(0..<3) { index in
                    let choice = viewModel.choices[index]

                    ChoiceView(choice: choice, size: answerSize)
                        .onTapGesture {
                            viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }
            GridRow {
                ForEach(3..<6) { index in
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
