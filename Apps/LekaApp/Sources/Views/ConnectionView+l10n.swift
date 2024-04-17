// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum ConnectionView {
        static let title = LocalizedString("lekaapp.connection_view.title", value: "Account connection", comment: "ConnectionView title")

        static let connectionButton = LocalizedString("lekaapp.connection_view.connection_button", value: "Connect", comment: "ConnectionView connection button")

        static let passwordForgottenButton = LocalizedString("lekaapp.connection_view.password_forgotten_button", value: "Forgot password?", comment: "ConnectionView password forgotten button")

        static let alertTitle = LocalizedString("lekaapp.connection_view.alert_title", value: "Forgot Password?", comment: "Forgot Password alert title")

        static let alertMessage = LocalizedString("lekaapp.connection_view.alert_message",
                                                  value: """
                                                      For security reasons, changes to your email or password need to be handled by our support team.
                                                      Please contact us at
                                                      support@leka.io
                                                      and we'll be happy to assist you with updating your account information.
                                                      """,
                                                  comment: "Forgot Password alert message")
    }
}

// swiftlint:enable line_length
