// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - SuperSimonChoiceView

struct SuperSimonChoiceView: View {
    // MARK: Lifecycle

    private init(color: String, state: GameplayChoiceState, size: CGFloat, isTappable: Bool = true) {
        self.color = color
        self.state = state
        self.size = size
        self.isTappable = isTappable
    }

    init(choice: GameplaySuperSimonChoiceModel, size: CGFloat, isTappable: Bool = true) {
        self.init(color: choice.color, state: choice.state, size: size, isTappable: isTappable)
    }

    // MARK: Internal

    let color: String
    let state: GameplayChoiceState

    let size: CGFloat
    var isTappable = true

    var body: some View {
        Group {
            ChoiceColorView(color: self.color, size: self.size, state: self.state)
                .overlay(
                    Circle()
                        .fill(self.isTappable ? .clear : .white.opacity(0.6))
                )
                .animation(.easeOut(duration: 0.3), value: self.isTappable)
        }
        .contentShape(Circle())
    }
}

// MARK: - l10n.SuperSimonChoiceView

extension l10n {
    enum SuperSimonChoiceView {
        static let typeUnknownError = LocalizedString("game_engine_kit.super_simon_choice_view.type_unknown_error",
                                                      bundle: ContentKitResources.bundle,
                                                      value: "❌ ERROR\nChoice type not implemented",
                                                      comment: "SuperSimonChoiceView type unknown error label")
    }
}
