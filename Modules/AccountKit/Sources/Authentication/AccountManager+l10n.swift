// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum AccountManager {
        static let signupFailedError = LocalizedString("accountkit.auth_manager.signup_failed_error", value: "Sign-up failed. Please try again later.", comment: "Sign-up failure error message")

        static let verificationEmailFailure = LocalizedString("accountkit.auth_manager.verification_email_failed_error", value: "There was an error sending the verification email. Please try again later.", comment: "Verification email failure error message")
    }
}

// swiftlint:enable line_length
