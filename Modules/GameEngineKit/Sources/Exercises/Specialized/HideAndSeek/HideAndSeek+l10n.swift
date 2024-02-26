// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting line_length

extension l10n {
    enum HideAndSeekView {
        enum Launcher {
            static let instructions = LocalizedString("lekaapp.hide_and_seek_view.launcher.instructions", value: "Press OK when Leka is hidden", comment: "HideAndSeekView Launcher instructions")

            static let okButtonLabel = LocalizedString("lekaapp.hide_and_seek_view.launcher.ok_button_label", value: "Ok", comment: "HideAndSeekView Laucher OK button label")
        }

        enum Player {
            static let instructions = LocalizedString("lekaapp.hide_and_seek_view.player.instructions",
                                                      value: """
                                                          Encourage the care receiver to seek Leka.
                                                          You can throw a reinforcer to give him
                                                          a visual and/or audible clue.
                                                          Press FOUND ! once the robot found.
                                                          """,
                                                      comment: "HideAndSeekView Player instructions")

            static let foundButtonLabel = LocalizedString("lekaapp.hide_and_seek_view.player.found_button_label", value: "Found !", comment: "HideAndSeekView Player Found Button label")
        }
    }
}

// swiftlint:enable nesting line_length
