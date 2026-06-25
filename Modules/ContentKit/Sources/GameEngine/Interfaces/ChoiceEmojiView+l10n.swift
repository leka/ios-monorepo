// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// MARK: - l10n.ChoiceEmojiView

extension l10n {
    enum ChoiceEmojiView {
        static let emojiError = LocalizedStringInterpolation(
            "game_engine_kit.choice_emoji_view.emoji_error",
            bundle: ContentKitResources.bundle,
            value: "❌\nText is not emoji:\n%1$@",
            comment: "ChoiceEmojiView emoji error "
        )
    }
}
