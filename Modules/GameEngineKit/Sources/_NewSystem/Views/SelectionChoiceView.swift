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

    private init(choice: SelectionChoice, state: GameplayChoiceState, size: CGFloat, isTappable: Bool = true) {
        self.choice = choice
        self.state = state
        self.size = size
        self.isTappable = isTappable
    }

    init(choice: GameplaySelectionChoiceModel, size: CGFloat, isTappable: Bool = true) {
        self.init(choice: choice.choice, state: choice.state, size: size, isTappable: isTappable)
    }

    var body: some View {
        // TODO(@ladislas): Add text
        switch choice.type {
            case .color:
                ChoiceColorView(color: choice.value, size: size, state: state)
                    .overlay(
                        Circle()
                            .fill(isTappable ? .clear : .white.opacity(0.6))
                    )
                    .animation(.easeOut(duration: 0.3), value: isTappable)
            case .image:
                ChoiceImageView(image: choice.value, size: size, state: state)
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
