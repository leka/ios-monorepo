// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum ConnectionView {
        static let title = LocalizedString("lekaapp.connection_view.title", value: "Account connection", comment: "ConnectionView title")

        static let connectionButton = LocalizedString("lekaapp.connection_view.connection_button", value: "Connect", comment: "ConnectionView connection button")

        static let passwordForgottenButton = LocalizedString("lekaapp.connection_view.password_forgotten_button", value: "[Forgot password?](https://leka.io)", comment: "ConnectionView password forgotten button")
    }
}

// swiftlint:enable line_length
