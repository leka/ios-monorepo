// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ThreeChoicesInlineView: View {
    @ObservedObject private var viewModel: ThreeChoicesInlineVM

    public init(viewModel: ThreeChoicesInlineVM) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 50) {
            HStack(spacing: 100) {
                ForEach(viewModel.choices) { choice in
                    ColoredAnswerView(color: choice.color, status: choice.status)
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    viewModel.onChoiceTapped(choice: choice)
                                }
                        )
                }
            }

            if viewModel.isFinished {
                Text("Well done !")
                    .font(.title)
            }
        }
    }
}
