// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum ColorMediatorView {
        enum ColorSelector {
            static let instruction = LocalizedString("game_engine_kit.color_mediator_view.color_selector.instruction",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Select colors you want to play with",
                                                     comment: "Color selector instruction ")

            static let selectLabel = LocalizedString("game_engine_kit.color_mediator_view.color_selector.select_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Select",
                                                     comment: "ColorSelector select button label")

            static let closeLabel = LocalizedString("game_engine_kit.color_mediator_view.color_selector.close_label",
                                                    bundle: ContentKitResources.bundle,
                                                    value: "Close",
                                                    comment: "ColorSelector close button label")
        }

        static let shuffleColorLabel = LocalizedString("game_engine_kit.color_mediator_view.shuffle_color_label",
                                                       bundle: ContentKitResources.bundle,
                                                       value: "Shuffle",
                                                       comment: "Label of shuffle color button of ColorMediatorView")

        static let playButtonLabel = LocalizedString("game_engine_kit.color_mediator_view.play_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Start coloring Leka",
                                                     comment: "Label under Play button of ColorMediatorView")

        static let nextButtonLabel = LocalizedString("game_engine_kit.color_mediator_view.next_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Next color",
                                                     comment: "Label under Next button of ColorMediatorView")

        static let stopButtonLabel = LocalizedString("game_engine_kit.color_mediator_view.stop_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Stop coloring Leka",
                                                     comment: "Label under Stop button of ColorMediatorView")

        static let robotColorLabel = LocalizedString("game_engine_kit.color_mediator_view.robot_color",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Robot color",
                                                     comment: "Label under robot color visual of ColorMediatorView")

        static let chooseColorsButtonLabel = LocalizedString("game_engine_kit.color_mediator_view.choose_colors_button_label",
                                                             bundle: ContentKitResources.bundle,
                                                             value: "Choose colors",
                                                             comment: "Choose colors button label of ColorMediatorView")
    }
}
