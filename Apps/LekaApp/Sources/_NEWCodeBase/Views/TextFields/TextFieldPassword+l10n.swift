// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum TextFieldPassword {
        static let label = LocalizedString("lekaapp.TextFieldPassword.label", value: "Password", comment: "TextFieldPassword label")

        static let invalidPasswordErrorLabel = LocalizedString("lekaapp.TextFieldPassword.invalidPasswordErrorLabel", value: "8 characters minimum, including at least one number and one Capital letter.", comment: "TextFieldPassword invalid Password Error Label")
    }
}

// swiftlint:enable line_length
