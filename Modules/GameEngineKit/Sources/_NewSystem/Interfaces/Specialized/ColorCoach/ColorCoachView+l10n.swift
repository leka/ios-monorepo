// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum ColorCoachView {
        enum ColorSelector {
            static let instruction = LocalizedString("game_engine_kit.color_coach_view.color_selector.instruction",
                                                     bundle: GameEngineKitResources.bundle,
                                                     value: "Select colors you want to play with",
                                                     comment: "Color selector instruction ")

            static let selectLabel = LocalizedString("game_engine_kit.color_coach_view.color_selector.select_label",
                                                     bundle: GameEngineKitResources.bundle,
                                                     value: "Select",
                                                     comment: "ColorSelector select button label")

            static let closeLabel = LocalizedString("game_engine_kit.color_coach_view.color_selector.close_label",
                                                    bundle: GameEngineKitResources.bundle,
                                                    value: "Close",
                                                    comment: "ColorSelector close button label")
        }

        static let instructions = LocalizedString("game_engine_kit.color_coach_view.instructions",
                                                  bundle: GameEngineKitResources.bundle,
                                                  value: "Press Play to start coloring Leka",
                                                  comment: "ColorCoachView instructions")

        static let playButtonLabel = LocalizedString("game_engine_kit.color_coach_view.play_button_label",
                                                     bundle: GameEngineKitResources.bundle,
                                                     value: "Start coloring Leka",
                                                     comment: "Label under Play button of ColorCoachView")

        static let nextButtonLabel = LocalizedString("game_engine_kit.color_coach_view.next_button_label",
                                                     bundle: GameEngineKitResources.bundle,
                                                     value: "Next color",
                                                     comment: "Label under Next button of ColorCoachView")

        static let stopButtonLabel = LocalizedString("game_engine_kit.color_coach_view.stop_button_label",
                                                     bundle: GameEngineKitResources.bundle,
                                                     value: "Stop coloring Leka",
                                                     comment: "Label under Stop button of ColorCoachView")

        static let robotColorLabel = LocalizedString("game_engine_kit.color_coach_view.robot_color",
                                                     bundle: GameEngineKitResources.bundle,
                                                     value: "Robot color",
                                                     comment: "Label under robot color visual of ColorCoachView")

        static let chooseColorsButtonLabel = LocalizedString("game_engine_kit.color_coach_view.choose_colors_button_label",
                                                             bundle: GameEngineKitResources.bundle,
                                                             value: "Choose colors",
                                                             comment: "Choose colors button label of ColorCoachView")
    }
}
