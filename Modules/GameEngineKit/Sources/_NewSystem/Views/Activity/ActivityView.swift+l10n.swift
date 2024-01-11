// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting

extension l10n {
    enum GameEngineKit {
        enum ActivityView {
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

// swiftlint:enable nesting
