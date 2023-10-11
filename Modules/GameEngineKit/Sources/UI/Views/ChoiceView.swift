// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ChoiceView: View {
    var choice: ChoiceModel
    let size: CGFloat
    var isTappable = true

    var body: some View {
        switch choice.type {
            case .color:
                ColoredAnswerView(color: choice.item, size: size, status: choice.status)
                    .overlay(
                        Circle()
                            .fill(isTappable ? .clear : .white.opacity(0.6))
                    )
                    .animation(.easeOut(duration: 0.3), value: isTappable)
            case .image:
                ImageAnswerView(image: choice.item, size: size, status: choice.status)
                    .overlay(
                        Circle()
                            .fill(isTappable ? .clear : .white.opacity(0.6))
                    )
                    .animation(.easeOut(duration: 0.3), value: isTappable)
            case .text:
                TextAnswerView(text: choice.item, size: size, status: choice.status)
                    .overlay(
                        Circle()
                            .fill(isTappable ? .clear : .white.opacity(0.6))
                    )
                    .animation(.easeOut(duration: 0.3), value: isTappable)
        }
    }
}
