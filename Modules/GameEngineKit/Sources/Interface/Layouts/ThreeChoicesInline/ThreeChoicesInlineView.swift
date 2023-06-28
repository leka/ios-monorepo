// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ThreeChoicesInlineView: View {
    @ObservedObject private var viewModel: GenericViewModel

    public init(viewModel: GenericViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 50) {
            HStack(spacing: 100) {
                ForEach(0..<3) { index in
                    let item = viewModel.choices[index].item
                    let choice = viewModel.choices[index]

                    switch choice.type {
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
