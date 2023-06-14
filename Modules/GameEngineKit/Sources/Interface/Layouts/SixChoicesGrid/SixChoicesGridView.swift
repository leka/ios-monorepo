// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct SixChoicesGridView: View {
    @ObservedObject private var viewModel: SixChoicesGridVM

    public init(viewModel: SixChoicesGridVM) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Grid(
            horizontalSpacing: 30,
            verticalSpacing: 30
        ) {
            GridRow {
                ForEach(viewModel.choices[0..<3]) { choice in
                    ColoredAnswerView(color: choice.color, status: choice.status)
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    viewModel.onChoiceTapped(choice: choice)
                                })
                }
            }
            GridRow {
                ForEach(viewModel.choices[3..<6]) { choice in
                    ColoredAnswerView(color: choice.color, status: choice.status)
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    viewModel.onChoiceTapped(choice: choice)
                                })
                }
            }

            if viewModel.isFinished {
                Text("Well done !")
                    .font(.title)
            }
        }
    }
}
