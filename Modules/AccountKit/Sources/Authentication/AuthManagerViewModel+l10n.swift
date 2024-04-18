// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum AuthManagerViewModel {
        static let successfulEmailVerification = LocalizedString("accountkit.auth_manager_view_model.verification_email_success_notification", value: "Verification email sent. Please check your inbox.", comment: "Verification email success notification message")

        static let unverifiedEmailNotification = LocalizedString("accountkit.auth_manager_view_model.unverified_email_notification", value: "Your email hasn't been verified yet. Please verify your email to avoid losing your data.", comment: "Unverified email notification message")
    }
}

// swiftlint:enable line_length
