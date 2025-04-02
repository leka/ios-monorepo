// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum EnterNewEmailView {
        static let title = LocalizedString(
            "lekaapp.enter_new_email_view.title",
            value: "Change your email",
            comment: "Title for view that requests new email input"
        )

        static let confirmButton = LocalizedString(
            "lekaapp.enter_new_email_view.confirm_button",
            value: "Confirm new email",
            comment: "Button to confirm email change"
        )
    }
}
