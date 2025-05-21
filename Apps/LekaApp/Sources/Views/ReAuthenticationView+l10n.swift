// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum ReAuthenticationView {
        static let title = LocalizedString(
            "lekaapp.re_authentication_view.title",
            value: "Confirm Account Deletion",
            comment: "ReAuthentication view title"
        )

        static let contextMessage = LocalizedString(
            "lekaapp.re_authentication_view.context_message",
            value: """
                Please enter your password to confirm that you want
                to permanently delete your account.

                Once you delete your account, there is no going back.

                **All your data will be lost forever.**
                *Please be certain.*
                """,
            comment: "ReAuthentication view context message"
        )

        static let reAuthenticationFailedError = LocalizedString("lekaapp.re_authentication_view.re_authentication_failed_error",
                                                                 value: "Authentication failed. Please verify your password.",
                                                                 comment: "ReAuthentication failure error message")

        static let reauthAndDeleteAccountButton = LocalizedString(
            "lekaapp.re_authentication_view.connection_button",
            value: "Delete Account",
            comment: "ReAuthentication view connection button"
        )

        static let passwordForgottenButton = LocalizedString(
            "lekaapp.re_authentication_view.password_forgotten_button",
            value: "Forgot Password?",
            comment: "ReAuthentication view password forgotten button"
        )

        static let confirmResetPasswordAlertTitle = LocalizedString(
            "lekaapp.re_authentication_view.confirm_reset_password_alert_title",
            value: "Are you sure you want to reset your password?",
            comment: "Confirm reset password alert title"
        )

        static let confirmResetPasswordAlertMessage = LocalizedString(
            "lekaapp.re_authentication_view.confirm_reset_password_alert_message",
            value: """
                We will send you an e-mail with a link to reset your password.
                Are you sure you want to continue?
                """,
            comment: "Confirm reset password alert message"
        )

        static let resetPasswordButtonLabel = LocalizedString(
            "lekaapp.re_authentication_view.reset_password_button_label",
            value: "Reset Password",
            comment: "Confirm Reset password button label"
        )

        static let cancelResetPasswordButtonLabel = LocalizedString(
            "lekaapp.re_authentication_view.cancel_reset_password_button_label",
            value: "Cancel",
            comment: "Cancel Reset password button label"
        )
    }
}
