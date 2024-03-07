// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum MelodyView {
        static let musicSelectionTitle = LocalizedString("lekaapp.melody_view.song_selector_title",
                                                         bundle: GameEngineKitResources.bundle,
                                                         value: "Music selection",
                                                         comment: "MelodyView music selection title")

        static let playButtonLabel = LocalizedString("lekaapp.melody_view.play_button_label",
                                                     bundle: GameEngineKitResources.bundle,
                                                     value: "Play",
                                                     comment: "MelodyView play button label")

        static let partialKeyboardLabel = LocalizedString("lekaapp.melody_view.keyboard_partial",
                                                          bundle: GameEngineKitResources.bundle,
                                                          value: "Partial keyboard",
                                                          comment: "MelodyView partial keyboard label")

        static let fullKeyboardLabel = LocalizedString("lekaapp.melody_view.keyboard_full",
                                                       bundle: GameEngineKitResources.bundle,
                                                       value: "Full keyboard",
                                                       comment: "MelodyView keyboard full keyboard label")
    }
}
