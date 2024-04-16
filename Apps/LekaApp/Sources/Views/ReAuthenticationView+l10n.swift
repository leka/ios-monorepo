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

        static let passwordForgottenButton = LocalizedString("lekaapp.re_authentication_view.password_forgotten_button", value: "[Forgot password?](https://leka.io)", comment: "ReAuthentication view password forgotten button")
    }
}

// swiftlint:enable line_length
