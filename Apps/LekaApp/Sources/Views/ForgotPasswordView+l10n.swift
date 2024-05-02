// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum ForgotPasswordView {
        static let title = LocalizedString("lekaapp.forgot_password_view.title", value: "Reset Password", comment: "Forgot Password View title")

        static let contextMessage = LocalizedString("lekaapp.forgot_password_view.context_message",
                                                    value: """
                                                        For security reasons, we do not have access to your password, and therefore cannot provide it to you.

                                                        However, you can change your password after filling in your email address below.

                                                        You will then receive an email allowing you to choose a new one.
                                                        """,
                                                    comment: "Forgot Password View context message")

        static let resetPasswordButtonLabel = LocalizedString("lekaapp.forgot_password_view.reset_password_button_label", value: "Reset Password", comment: "Forgot Password View reset button label")

        static let successAlertTitle = LocalizedString("lekaapp.forgot_password_view.success_alert_title", value: "Reset Password", comment: "Password Reset success alert title")

        static let successAlertMessage = LocalizedString(
            "lekaapp.forgot_password_view.reset_password_success_alert_message",
            value: """
                The e-mail to change your password was sent successfuly.
                Please check your inbox.
                """,
            comment: "Password Reset success alert message"
        )

        static let errorAlertTitle = LocalizedString("lekaapp.forgot_password_view.error_alert_title", value: "Password Reset Error", comment: "Password Reset error alert title")

        static let errorAlertMessage = LocalizedString(
            "lekaapp.forgot_password_view.reset_password_error_alert_message",
            value: """
                We encountered an issue sending you an e-mail to reset your password.
                Please try again.

                If the problem persists, contact our support team for assistance.
                """,
            comment: "Password Reset error alert message"
        )
    }
}

// swiftlint:enable line_length
