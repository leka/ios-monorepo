// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum EnterNewEmailView {
        static let title = LocalizedString(
            "lekaapp.enter_new_email_view.title",
            value: "Change your email",
            comment: "Title for view that requests new email input"
        )

        static let contextMessage = LocalizedString(
            "lekaapp.enter_new_email_view.context_message",
            value: "Please type your new Email.",
            comment: "Context message to invite the user to type their new email"
        )

        static let confirmButton = LocalizedString(
            "lekaapp.enter_new_email_view.confirm_button",
            value: "Confirm new email",
            comment: "Button to confirm email change"
        )

        static let changeEmailFailureAlertTitle = LocalizedString(
            "lekaapp.enter_new_email_view.change_email_failure.alert_title",
            value: "Changing your email address failed",
            comment: "Change Email failure alert title"
        )

        static let changeEmailFailureAlertMessage = LocalizedString(
            "lekaapp.enter_new_email_view.change_email_failure.alert_message",
            value: """
                We encountered an issue while attempting to update your email.
                Please try again later or contact support if the problem persists.
                """,
            comment: "Change Email failure alert message"
        )

        static let changeEmailFailureAlertDismissButton = LocalizedString(
            "lekaapp.enter_new_email_view.change_email_failure.alert_dismiss_Button",
            value: "OK",
            comment: "Change Email failure alert dismiss button"
        )
    }
}
