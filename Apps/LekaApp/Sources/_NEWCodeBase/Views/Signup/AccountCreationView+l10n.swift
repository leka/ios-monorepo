// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum AccountCreationView {
        static let navigationTitle = LocalizedString("lekaapp.account_creation_view.navigation_title", value: "First connection", comment: "NavigationBar title on the whole Signup process")

        static let createAccountTitle = LocalizedString("lekaapp.account_creation_view.create_account_title", value: "Create an account", comment: "Create account title on SignupView")

        static let emailLabel = LocalizedString("lekaapp.account_creation_view.email_label", value: "Email", comment: "Email label on SignupView")

        static let passwordLabel = LocalizedString("lekaapp.account_creation_view.password_label", value: "Password", comment: "Password label on SignupView")

        static let confirmLabel = LocalizedString("lekaapp.account_creation_view.confirm_label", value: "Confirm Password", comment: "Confirm Password label on SignupView")

        static let connectionButton = LocalizedString("lekaapp.account_creation_view.connection_button", value: "Connection", comment: "Connection button on SignupView")
    }
}

// swiftlint:enable line_length
