// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

struct TouchToSelectChoiceView: View {
    // MARK: Lifecycle

    private init(choice: TouchToSelect.Choice, state: GameplayChoiceState, size: CGFloat, isTappable: Bool = true) {
        self.choice = choice
        self.state = state
        self.size = size
        self.isTappable = isTappable
    }

    init(choice: GameplayTouchToSelectChoiceModel, size: CGFloat, isTappable: Bool = true) {
        self.init(choice: choice.choice, state: choice.state, size: size, isTappable: isTappable)
    }

    // MARK: Internal

    let choice: TouchToSelect.Choice
    let state: GameplayChoiceState

    let size: CGFloat
    var isTappable = true

    var body: some View {
        // TODO(@ladislas): Add text
        Group {
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
                    Text("❌ ERROR\nChoice type not implemented")
                        .multilineTextAlignment(.center)
                        .onAppear {
                            log.error("Choice type \(choice.type) not implemented for choice: \(choice)")
                        }
            }
        }
        .contentShape(Circle())
    }
}
