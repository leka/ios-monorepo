// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum ChangeEmailView {
        static let title = LocalizedString(
            "lekaapp.change_email_view.title",
            value: "Confirm Email Change",
            comment: "ChangeEmailView title"
        )

        static let contextMessage = LocalizedString(
            "lekaapp.change_email_view.context_message",
            value: """
                Please confirm your identity by entering your password.

                You're about to change the email associated with this account.

                **All profiles linked to this account will be affected.**
                *Please be certain.*
                """,
            comment: "ChangeEmailView context message"
        )

        static let reauthAndChangeEmailButton = LocalizedString(
            "lekaapp.change_email_view.reauth_and_change_email_button",
            value: "Continue",
            comment: "ChangeEmailView reauth button label"
        )
    }
}

// swiftlint:enable line_length
