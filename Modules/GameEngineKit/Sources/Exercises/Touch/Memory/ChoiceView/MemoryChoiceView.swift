// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - MemoryChoiceView

struct MemoryChoiceView: View {
    // MARK: Lifecycle

    private init(choice: Memory.Choice, state: GameplayChoiceState, size: CGFloat, isTappable: Bool = true) {
        self.choice = choice
        self.state = state
        self.size = size
        self.isTappable = isTappable
    }

    init(choice: GameplayAssociateCategoriesChoiceModelMemory, size: CGFloat, isTappable: Bool = true) {
        self.init(choice: choice.choice, state: choice.state, size: size, isTappable: isTappable)
    }

    // MARK: Internal

    let choice: Memory.Choice
    let state: GameplayChoiceState

    let size: CGFloat
    var isTappable = true

    var body: some View {
        Group {
            switch self.choice.type {
                case .image:
                    ImageView(image: self.choice.value, size: self.size, state: self.state)
                case .color:
                    ColorView(color: self.choice.value, size: self.size, state: self.state)
                case .sfsymbol:
                    SFSymbolView(sfsymbol: self.choice.value, size: self.size, state: self.state)
                case .emoji:
                    EmojiView(emoji: self.choice.value, size: self.size, state: self.state)
                default:
                    Text(l10n.MemoryChoiceView.typeUnknownError)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            log.error("Choice type \(self.choice.type) not implemented for choice: \(self.choice)")
                        }
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - l10n.MemoryChoiceView

extension l10n {
    enum MemoryChoiceView {
        static let typeUnknownError = LocalizedString("game_engine_kit.memory_choice_view.type_unknown_error",
                                                      bundle: GameEngineKitResources.bundle,
                                                      value: "❌ ERROR\nChoice type not implemented",
                                                      comment: "MemoryChoiceView type unknown error label")
    }
}
