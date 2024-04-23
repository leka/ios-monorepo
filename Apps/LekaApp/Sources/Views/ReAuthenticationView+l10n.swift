// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum ReAuthenticationView {
        static let title = LocalizedString("lekaapp.re_authentication_view.title", value: "Account Deletion", comment: "ReAuthentication view title")

        static let contextMessage = LocalizedString("lekaapp.re_authentication_view.context_message",
                                                    value: """
                                                        Once you delete your account, there is no going back.

                                                        **All your data will be lost forever.**
                                                        *Please be certain.*

                                                        You need to re-authenticate using your password to delete your account.
                                                        """,
                                                    comment: "ReAuthentication view context message")

        static let connectionButton = LocalizedString("lekaapp.re_authentication_view.connection_button", value: "Connect", comment: "ReAuthentication view connection button")

        static let passwordForgottenButton = LocalizedString("lekaapp.re_authentication_view.password_forgotten_button", value: "Forgot password?", comment: "ReAuthentication view password forgotten button")

        static let confirmResetPasswordAlertTitle = LocalizedString("lekaapp.re_authentication_view.confirm_reset_password_alert_title", value: "Reset Password?", comment: "Confirm reset password alert title")

        static let confirmResetPasswordAlertMessage = LocalizedString(
            "lekaapp.re_authentication_view.confirm_reset_password_alert_message",
            value: """
                Please confirm the resetting of your password by using the button below. You will then receive an email allowing you to enter a new one.
                """,
            comment: "Confirm reset password alert message"
        )

        static let resetPasswordButtonLabel = LocalizedString("lekaapp.re_authentication_view.reset_password_button_label", value: "Reset Password", comment: "Confirm Reset password button label")

        static let cancelResetPasswordButtonLabel = LocalizedString("lekaapp.re_authentication_view.cancel_reset_password_button_label", value: "Cancel", comment: "Cancel Reset password button label")
    }
}

// swiftlint:enable line_length
