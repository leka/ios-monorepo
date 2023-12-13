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
        Group {
            switch self.choice.type {
                case .color:
                    ChoiceColorView(color: self.choice.value, size: self.size, state: self.state)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)

                case .image:
                    ChoiceImageView(image: self.choice.value, size: self.size, state: self.state)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)

                case .sfsymbol:
                    ChoiceSFSymbolView(image: self.choice.value, size: self.size, state: self.state)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)

                case .emoji:
                    ChoiceEmojiView(emoji: self.choice.value, size: self.size, state: self.state)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)

                default:
                    Text("❌ ERROR\nChoice type not implemented")
                        .multilineTextAlignment(.center)
                        .onAppear {
                            log.error("Choice type \(self.choice.type) not implemented for choice: \(self.choice)")
                        }
            }
        }
        .contentShape(Circle())
    }
}
