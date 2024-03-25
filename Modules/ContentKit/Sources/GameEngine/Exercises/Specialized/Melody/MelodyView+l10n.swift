// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum MelodyView {
        static let musicSelectionTitle = LocalizedString("game_engine_kit.melody_view.song_selector_title",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Music selection",
                                                         comment: "MelodyView music selection title")

        static let playButtonLabel = LocalizedString("game_engine_kit.melody_view.play_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Play",
                                                     comment: "MelodyView play button label")

        static let partialKeyboardLabel = LocalizedString("game_engine_kit.melody_view.keyboard_partial",
                                                          bundle: ContentKitResources.bundle,
                                                          value: "Partial keyboard",
                                                          comment: "MelodyView partial keyboard label")

        static let fullKeyboardLabel = LocalizedString("game_engine_kit.melody_view.keyboard_full",
                                                       bundle: ContentKitResources.bundle,
                                                       value: "Full keyboard",
                                                       comment: "MelodyView keyboard full keyboard label")
    }
}
