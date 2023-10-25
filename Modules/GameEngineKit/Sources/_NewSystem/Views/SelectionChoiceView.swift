// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

struct SelectionChoiceView: View {

    let choice: SelectionChoice
    let state: GameplayChoiceState

    let size: CGFloat
    var isTappable = true

    init(choice: SelectionChoice, state: GameplayChoiceState, size: CGFloat, isTappable: Bool = true) {
        self.choice = choice
        self.state = state
        self.size = size
        self.isTappable = isTappable
    }

    var body: some View {
        // TODO(@ladislas): Add image and text
        switch choice.type {
            case .color:
                ChoiceColorView(color: choice.value, size: size, state: state)
                    .overlay(
                        Circle()
                            .fill(isTappable ? .clear : .white.opacity(0.6))
                    )
                    .animation(.easeOut(duration: 0.3), value: isTappable)

            default:
                Text("ERROR")
        }
    }

}
