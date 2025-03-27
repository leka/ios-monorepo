// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting

extension l10n {
    enum GameEngineKit {
        enum ActivityView {
            enum QuitActivityAlert {
                static let title = LocalizedString("game_engine_kit.activity_view.quit_activity_alert.title",
                                                   bundle: ContentKitResources.bundle,
                                                   value: "Leave activity?",
                                                   comment: "Quit activity alert title")

                static let message = LocalizedString("game_engine_kit.activity_view.quit_activity_alert.message",
                                                     bundle: ContentKitResources.bundle,
                                                     value: """
                                                         Are you sure you want to quit this activity?
                                                         """,
                                                     comment: "Quit activity alert message")

                static let quitButtonLabel = LocalizedString("game_engine_kit.activity_view.quit_activity_alert.quit_button_label",
                                                             bundle: ContentKitResources.bundle,
                                                             value: "Quit",
                                                             comment: "Quit activity alert quit button label")

                static let cancelButtonLabel = LocalizedString("game_engine_kit.activity_view.quit_activity_alert.cancel_button_label",
                                                               bundle: ContentKitResources.bundle,
                                                               value: "Cancel",
                                                               comment: "Quit activity alert cancel button label")
            }

            enum Toolbar {
                static let dismissButton = LocalizedString(
                    "game_engine_kit.activity_view.toolbar.dismiss_button",
                    bundle: ContentKitResources.bundle,
                    value: "Dismiss",
                    comment: "The title of the dismiss button"
                )
            }

            static let continueButton = LocalizedString(
                "game_engine_kit.activity_view.continue_button",
                bundle: ContentKitResources.bundle,
                value: "Continue",
                comment: "The title of the continue button"
            )

            static let finishButton = LocalizedString(
                "game_engine_kit.activity_view.finish_button",
                bundle: ContentKitResources.bundle,
                value: "Finish",
                comment: "The title of the finish button"
            )

            static let hideReinforcerToShowAnswersButton = LocalizedString(
                "game_engine_kit.activity_view.hide_reinforcer_to_show_answers_button",
                bundle: ContentKitResources.bundle,
                value: "Review answers",
                comment: "The title of the hide reinforcer to show answers button"
            )
        }
    }
}

// swiftlint:enable nesting line_length
