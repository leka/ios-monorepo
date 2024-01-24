// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum PairingView {
        static let instructions = LocalizedString("lekaapp.pairing_view.player.instructions",
                                                  value: """
                                                      Pairing mode allows the accompanied person to become familiar with Leka
                                                      before even entering into learning Activities and Curriculums.
                                                      The robot will come to life, taking pauses so that the care receiver can
                                                      tame your new companion!
                                                      """,
                                                  comment: "PairingView instructions")

        static let playButtonLabel = LocalizedString("lekaapp.pairing_view.play_button_label", value: "Play", comment: "PairingView play button label")

        static let pauseButtonLabel = LocalizedString("lekaapp.pairing_view.pause_button_label", value: "Pause", comment: "PairingView pause button label")

        static let stopButtonLabel = LocalizedString("lekaapp.pairing_view.stop_button_label", value: "Stop", comment: "PairingView stop button label")
    }
}

// swiftlint:enable line_length
