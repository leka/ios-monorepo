// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct SixChoicesGridView: View {
    @ObservedObject private var viewModel: SixChoicesGridViewModel

    public init(gameplay: any GameplayProtocol) {
        self.viewModel = SixChoicesGridViewModel(gameplay: gameplay)
    }

    public var body: some View {
        Grid(
            horizontalSpacing: 30,
            verticalSpacing: 30
        ) {
            GridRow {
                ForEach(0..<3) { index in
                    let choice = viewModel.choices[index]

                    ChoiceView(choice: choice)
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    viewModel.onChoiceTapped(choice: choice)
                                }
                        )
                }
            }
            GridRow {
                ForEach(3..<6) { index in
                    let choice = viewModel.choices[index]

                    ChoiceView(choice: choice)
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    viewModel.onChoiceTapped(choice: choice)
                                }
                        )
                }
            }
        }
    }
}
