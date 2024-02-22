// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length nesting

extension l10n {
    enum AccountCreationView {
        enum EmailVerificationAlert {
            static let title = LocalizedString("lekaapp.account_creation_view.email_verification_alert.title", value: "Confirm your email address", comment: "Email verification alert title")

            static let message = LocalizedString("lekaapp.account_creation_view.email_verification_alert.message",
                                                 value: "An email has been sent to the address provided. Please click on the link to confirm your email address.",
                                                 comment: "Email verification alert message")

            static let dismissButton = LocalizedString("lekaapp.account_creation_view.email_verification_alert.dismissButton", value: "OK", comment: "Email verification alert dismiss button")
        }

        static let createAccountTitle = LocalizedString("lekaapp.account_creation_view.create_account_title", value: "Create an account", comment: "Create account title on SignupView")

        static let connectionButton = LocalizedString("lekaapp.account_creation_view.connection_button", value: "Connection", comment: "Connection button on SignupView")
    }
}

// swiftlint:enable line_length nesting
