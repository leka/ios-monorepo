// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting

extension l10n {
    enum HideAndSeekView {
        enum Launcher {
            static let instructions = LocalizedString("game_engine_kit.hide_and_seek_view.launcher.instructions",
                                                      bundle: GameEngineKitResources.bundle,
                                                      value: "Press OK when Leka is hidden",
                                                      comment: "HideAndSeekView Launcher instructions")

            static let okButtonLabel = LocalizedString("game_engine_kit.hide_and_seek_view.launcher.ok_button_label",
                                                       bundle: GameEngineKitResources.bundle,
                                                       value: "Ok",
                                                       comment: "HideAndSeekView Laucher OK button label")
        }

        enum Player {
            static let instructions = LocalizedString("game_engine_kit.hide_and_seek_view.player.instructions",
                                                      bundle: GameEngineKitResources.bundle,
                                                      value: """
                                                          Encourage the care receiver to seek Leka.
                                                          You can throw a reinforcer to give him
                                                          a visual and/or audible clue.
                                                          Press FOUND! once the robot found.
                                                          """,
                                                      comment: "HideAndSeekView Player instructions")

            static let foundButtonLabel = LocalizedString("game_engine_kit.hide_and_seek_view.player.found_button_label",
                                                          bundle: GameEngineKitResources.bundle,
                                                          value: "Found!",
                                                          comment: "HideAndSeekView Player Found Button label")
        }
    }
}

// swiftlint:enable nesting
