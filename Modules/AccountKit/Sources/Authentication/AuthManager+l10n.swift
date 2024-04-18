// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum AuthManager {
        static let signupFailedError = LocalizedString("accountkit.auth_manager.signup_failed_error",
                                                       bundle: AccountKitResources.bundle,
                                                       value: "Sign-up failed. Please try again later.",
                                                       comment: "Sign-up failure error message")

        static let signInFailedError = LocalizedString("accountkit.auth_manager.signin_failed_error",
                                                       bundle: AccountKitResources.bundle,
                                                       value: "Sign-in failed. Please try again.",
                                                       comment: "Sign-in failure error message")

        static let verificationEmailFailure = LocalizedString("accountkit.auth_manager.verification_email_failed_error",
                                                              bundle: AccountKitResources.bundle,
                                                              value: "There was an error sending the verification email. Please try again later.",
                                                              comment: "Verification email failure error message")

        static let signOutFailedError = LocalizedString("accountkit.auth_manager.signout_failed_error",
                                                        bundle: AccountKitResources.bundle,
                                                        value: "Failed to sign out. Please try again.",
                                                        comment: "Sign-out failure error message")

        static let reAuthenticationFailedError = LocalizedString("accountkit.auth_manager.re_authentication_failed_error",
                                                                 bundle: AccountKitResources.bundle,
                                                                 value: "Authentication failed. Please verify your password.",
                                                                 comment: "ReAuthentication failure error message")

        static let reAuthenticationNoEmailFound = LocalizedString("accountkit.auth_manager.re_authentication_no_email-found",
                                                                  bundle: AccountKitResources.bundle,
                                                                  value: "No email found for the current user.",
                                                                  comment: "ReAuthentication no email found error message")
    }
}
