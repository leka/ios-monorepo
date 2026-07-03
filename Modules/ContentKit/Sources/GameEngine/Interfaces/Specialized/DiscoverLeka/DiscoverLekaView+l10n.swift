// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum DiscoverLekaView {
        static let instructions = LocalizedString("game_engine_kit.discover_leka_view.player.instructions",
                                                  bundle: ContentKitResources.bundle,
                                                  value: """
                                                      "Discover Leka" allows the accompanied person to become familiar with Leka
                                                      before even entering into learning Activities and Curriculums.
                                                      The robot will come to life, taking pauses so that the care receiver can
                                                      tame your new companion!
                                                      """,
                                                  comment: "DiscoverLekaView instructions")

        static let playButtonLabel = LocalizedString("game_engine_kit.discover_leka_view.play_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Play",
                                                     comment: "Discover LekaView play button label")

        static let pauseButtonLabel = LocalizedString("game_engine_kit.discover_leka_view.pause_button_label",
                                                      bundle: ContentKitResources.bundle,
                                                      value: "Pause",
                                                      comment: "DiscoverLekaView pause button label")

        static let stopButtonLabel = LocalizedString("game_engine_kit.discover_leka_view.stop_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Stop",
                                                     comment: "DiscoverLekaView stop button label")
    }
}
