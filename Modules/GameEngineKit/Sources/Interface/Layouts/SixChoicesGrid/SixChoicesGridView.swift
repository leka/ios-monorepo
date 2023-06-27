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
                ForEach(0..<3) { index in
                    let item = viewModel.choices[index].item
                    let choice = viewModel.choices[index]

                    switch viewModel.types[index] {
                        case .color:
                            ColoredAnswerView(color: item, status: choice.status)
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            viewModel.onChoiceTapped(choice: choice)
                                        }
                                )
                        case .image:
                            ImageAnswerView(image: item, status: choice.status)
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            viewModel.onChoiceTapped(choice: choice)
                                        }
                                )
                        case .text:
                            TextAnswerView(text: item, status: choice.status)
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            viewModel.onChoiceTapped(choice: choice)
                                        }
                                )
                    }
                }
            }
            GridRow {
                ForEach(3..<6) { index in
                    let item = viewModel.choices[index].item
                    let choice = viewModel.choices[index]

                    switch viewModel.types[index] {
                        case .color:
                            ColoredAnswerView(color: item, status: choice.status)
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            viewModel.onChoiceTapped(choice: choice)
                                        }
                                )
                        case .image:
                            ImageAnswerView(image: item, status: choice.status)
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            viewModel.onChoiceTapped(choice: choice)
                                        }
                                )
                        case .text:
                            TextAnswerView(text: item, status: choice.status)
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            viewModel.onChoiceTapped(choice: choice)
                                        }
                                )
                    }
                }
            }

            if viewModel.isFinished {
                Text("Well done !")
                    .font(.title)
            }
        }
    }
}
