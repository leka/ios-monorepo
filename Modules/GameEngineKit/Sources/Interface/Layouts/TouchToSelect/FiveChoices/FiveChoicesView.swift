// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct FiveChoicesView: View {
    @StateObject private var viewModel: GenericViewModel
    let horizontalSpacing: CGFloat = 6
    let verticalSpacing: CGFloat = 32
    let answerSize: CGFloat = 200

    public init(gameplay: any SelectionGameplayProtocol) {
        self._viewModel = StateObject(wrappedValue: GenericViewModel(gameplay: gameplay))
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
