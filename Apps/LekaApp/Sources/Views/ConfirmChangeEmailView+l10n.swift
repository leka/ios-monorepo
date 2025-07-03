// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum ConfirmChangeEmailView {
        static let title = LocalizedString(
            "lekaapp.confirm_change_email_view.title",
            value: "Confirm Email Change",
            comment: "ConfirmChangeEmailView title"
        )

        static let contextMessage = LocalizedString(
            "lekaapp.confirm_change_email_view.context_message",
            value: """
                Please confirm your identity by entering your password.

                You're about to change the email associated with this account.

                **All profiles linked to this account will be affected.**
                *Please be certain.*
                """,
            comment: "ConfirmChangeEmailView context message"
        )

        static let reauthAndChangeEmailButton = LocalizedString(
            "lekaapp.confirm_change_email_view.reauth_and_change_email_button",
            value: "Continue",
            comment: "ConfirmChangeEmailView reauth button label"
        )
    }
}
