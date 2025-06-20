// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// MARK: - l10n.LottieAnimation

extension l10n {
    enum LottieAnimation {
        enum ActivityEnd {
            static let successPercentageLabel = LocalizedStringInterpolation("game_engine_kit.lottie_view.activity_end.success_percentage_label",
                                                                             bundle: ContentKitResources.bundle,
                                                                             value: "%.0f%% of success!",
                                                                             comment: "ActivityEnd view success percentage label")

            static let successCheeringLabel = LocalizedString("game_engine_kit.lottie_view.activity_end.success_cheering_label",
                                                              bundle: ContentKitResources.bundle,
                                                              value: "Well done, you've succeeded this activity!",
                                                              comment: "ActivityEnd view cheering label")

            static let failureCheeringLabel = LocalizedString("game_engine_kit.lottie_view.activity_end.failure_cheering_label",
                                                              bundle: ContentKitResources.bundle,
                                                              value: "Try again!",
                                                              comment: "ActivityEnd view cheering label")

            static let quitButtonLabel = LocalizedString("game_engine_kit.lottie_view.activity_end.quit_button_label",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Quit",
                                                         comment: "ActivityEnd view quit button label")
        }

        enum Reinforcer {
            static let continueButton = LocalizedString(
                "game_engine_kit.lottie_view.reinforcer.continue_button",
                bundle: ContentKitResources.bundle,
                value: "Continue",
                comment: "The title of the continue button"
            )

            static let finishButton = LocalizedString(
                "game_engine_kit.lottie_view.reinforcer.finish_button",
                bundle: ContentKitResources.bundle,
                value: "Finish",
                comment: "The title of the finish button"
            )

            static let hideReinforcerToShowAnswersButton = LocalizedString(
                "game_engine_kit.lottie_view.reinforcer.hide_reinforcer_to_show_answers_button",
                bundle: ContentKitResources.bundle,
                value: "Review answers",
                comment: "The title of the hide reinforcer to show answers button"
            )
        }
    }
}
