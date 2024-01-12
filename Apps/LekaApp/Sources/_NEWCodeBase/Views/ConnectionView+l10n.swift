// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting line_length

extension l10n {
    enum ConnectionView {
        enum TextField {
            static let email = LocalizedString("lekaapp.connection_view.textfield.email", value: "Email", comment: "ConnectionView email textfield")
            static let emailNotCorrect = LocalizedString("lekaapp.connection_view.textfield.email_wrong_format", value: "Invalid email format", comment: "ConnectionView email textfield wrong format")

            static let password = LocalizedString("lekaapp.connection_view.textfield.password", value: "Password", comment: "ConnectionView password textfield")

            static let credentialsNotCorrect = LocalizedString("lekaapp.connection_view.textfield.credentials_are_not_correct", value: "Invalid email and password", comment: "ConnectionView password textfield credentials are not correct")
        }

        static let title = LocalizedString("lekaapp.connection_view.title", value: "Account connection", comment: "ConnectionView title")

        static let connectionButton = LocalizedString("lekaapp.connection_view.connection_button", value: "Connect", comment: "ConnectionView connection button")

        static let passwordForgottenButton = LocalizedString("lekaapp.connection_view.password_forgotten_button", value: "[Forgot password?](https://leka.io)", comment: "ConnectionView password forgotten button")
    }
}

// swiftlint:enable nesting line_length
