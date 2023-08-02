// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct FiveChoicesView: View {
    @ObservedObject private var viewModel: FiveChoicesViewModel
    let horizontalSpacing: CGFloat = 32
    let verticalSpacing: CGFloat = 32
    let answerSize: CGFloat = 200

    public init(gameplay: any GameplayProtocol) {
        self.viewModel = FiveChoicesViewModel(gameplay: gameplay)
    }

    public var body: some View {
        Grid(
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        ) {
            GridRow {
                ChoiceView(choice: viewModel.choices[0], size: answerSize)
                    .onTapGesture {
                        viewModel.onChoiceTapped(choice: viewModel.choices[0])
                    }
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                ChoiceView(choice: viewModel.choices[1], size: answerSize)
                    .onTapGesture {
                        viewModel.onChoiceTapped(choice: viewModel.choices[1])
                    }
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                ChoiceView(choice: viewModel.choices[2], size: answerSize)
                    .onTapGesture {
                        viewModel.onChoiceTapped(choice: viewModel.choices[2])
                    }
            }
            GridRow {
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                ChoiceView(choice: viewModel.choices[3], size: answerSize)
                    .onTapGesture {
                        viewModel.onChoiceTapped(choice: viewModel.choices[3])
                    }
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                ChoiceView(choice: viewModel.choices[4], size: answerSize)
                    .onTapGesture {
                        viewModel.onChoiceTapped(choice: viewModel.choices[4])
                    }
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
            }
        }
    }
}
