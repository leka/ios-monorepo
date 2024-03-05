// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting line_length

extension l10n {
    enum GameEngineKit {
        enum ActivityView {
            enum QuitActivityAlert {
                static let title = LocalizedString("gameenginekit.activity_view.quit_activity_alert.title", value: "Quit activity?", comment: "Quit activity alert title")

                static let message = LocalizedString("gameenginekit.activity_view.quit_activity_alert.message",
                                                     value: """
                                                         Do you want to save your progress before quitting?
                                                         """,
                                                     comment: "Quit activity alert message")

                static let quitWithoutSavingButtonLabel = LocalizedString("gameenginekit.activity_view.quit_activity_alert.quit_without_saving_button_label", value: "Quit Without Saving", comment: "Quit activity alert quit without saving button label")

                static let saveQuitButtonLabel = LocalizedString("gameenginekit.activity_view.quit_activity_alert.save_quit_button_label", value: "Save and Quit", comment: "Quit activity alert save and quit button label")

                static let cancelButtonLabel = LocalizedString("gameenginekit.activity_view.quit_activity_alert.cancel_button_label", value: "Cancel", comment: "Quit activity alert cancel button label")
            }

            enum Toolbar {
                static let dismissButton = LocalizedString(
                    "gameenginekit.activity_view.toolbar.dismiss_button", value: "Dismiss",
                    comment: "The title of the dismiss button"
                )
            }

            static let continueButton = LocalizedString(
                "gameenginekit.activity_view.continue_button", value: "Continue",
                comment: "The title of the continue button"
            )

            static let hideReinforcerToShowAnswersButton = LocalizedString(
                "gameenginekit.activity_view.hide_reinforcer_to_show_answers_button", value: "Review answers",
                comment: "The title of the hide reinforcer to show answers button"
            )
        }
    }
}

// swiftlint:enable nesting line_length
