// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ThreeChoicesInlineView: View {
    @ObservedObject private var viewModel: ThreeChoicesInlineViewModel

    public init(gameplay: any GameplayProtocol) {
        self.viewModel = ThreeChoicesInlineViewModel(gameplay: gameplay)
    }

    public var body: some View {
        VStack(spacing: 50) {
            HStack(spacing: 100) {
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

            if viewModel.isFinished {
                Text("Well done !")
                    .font(.title)
            }
        }
    }
}
