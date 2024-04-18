// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - TouchToSelectInRightOrderChoiceView

struct TouchToSelectInRightOrderChoiceView: View {
    // MARK: Lifecycle

    private init(choice: TouchToSelectInRightOrder.Choice, state: GameplayChoiceState, size: CGFloat, isTappable: Bool = true) {
        self.choice = choice
        self.state = state
        self.size = size
        self.isTappable = isTappable
    }

    init(choice: GameplayTouchToSelectInRightOrderChoiceModel, size: CGFloat, isTappable: Bool = true) {
        self.init(choice: choice.choice, state: choice.state, size: size, isTappable: isTappable)
    }

    // MARK: Internal

    let choice: TouchToSelectInRightOrder.Choice
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
                    Text(l10n.TouchToSelectInRightOrderChoiceView.typeUnknownError)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            log.error("Choice type \(self.choice.type) not implemented for choice: \(self.choice)")
                        }
            }
        }
        .contentShape(Circle())
    }
}

// MARK: - l10n.TouchToSelectInRightOrderChoiceView

extension l10n {
    enum TouchToSelectInRightOrderChoiceView {
        static let typeUnknownError = LocalizedString("game_engine_kit.touch_to_select_choice_view.type_unknown_error",
                                                      bundle: GameEngineKitResources.bundle,
                                                      value: "❌ ERROR\nChoice type not implemented",
                                                      comment: "TouchToSelectInRightOrderChoiceView type unknown error label")
    }
}
