// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting

extension l10n {
    enum SettingsView {
        enum CredentialsSection {
            enum ChangeCredentials {
                static let buttonLabel = LocalizedString(
                    "lekaapp.settings_view.credentials_section.change_credentials.button_label",
                    value: "Change Password",
                    comment: "Change credentials button label"
                )

                static let alertTitle = LocalizedString(
                    "lekaapp.settings_view.credentials_section.change_credentials.alert_title",
                    value: "Are you sure you want to change your password?",
                    comment: "Change credentials alert title"
                )

                static let alertMessage = LocalizedString(
                    "lekaapp.settings_view.credentials_section.change_credentials.alert_message",
                    value: """
                        We will send you an e-mail with a link to change your password.
                        Are you sure you want to continue?
                        """,
                    comment: "Change credentials alert message"
                )

                static let alertChangePasswordButtonLabel = LocalizedString(
                    "lekaapp.settings_view.credentials_section.change_credentials.reset_password_button_label",
                    value: "Change Password",
                    comment: "Reset password button label"
                )

                static let errorAlertTitle = LocalizedString(
                    "lekaapp.settings_view.credentials_section.change_credentials.error_alert_title",
                    value: "Failed to Send Email",
                    comment: "Password reset error alert title"
                )

                static let errorAlertMessage = LocalizedString(
                    "lekaapp.settings_view.credentials_section.change_credentials.error_alert_message",
                    value: """
                        We encountered an issue while attempting to send the email.
                        Please try again later or contact support if the problem persists.
                        """,
                    comment: "Password reset error alert message"
                )

                static let changePasswordSuccessAlertTitle = LocalizedString(
                    "lekaapp.settings_view.credentials_section.change_credentials.success_alert_title",
                    value: "Email Sent",
                    comment: "Password reset success alert title"
                )

                static let changePasswordSuccessAlertMessage = LocalizedString(
                    "lekaapp.settings_view.credentials_section.change_credentials.success_alert_message",
                    value: """
                        An email has been sent to your address with instructions to change your password.
                        Please check your inbox.
                        """,
                    comment: "Password reset success alert message"
                )
            }

            static let emailLabel = LocalizedString(
                "lekaapp.settings_view.credentials_section.email_label",
                value: "Account Email",
                comment: "Account email address label"
            )
        }

        enum AccountSection {
            enum LogOut {
                static let alertTitle = LocalizedString(
                    "lekaapp.settings_view.account_section.log_out.alert_title",
                    value: "Confirm Logout",
                    comment: "Log out alert title"
                )

                static let buttonLabel = LocalizedString(
                    "lekaapp.settings_view.account_section.log_out.button_label",
                    value: "Log Out",
                    comment: "Log out button label"
                )

                static let alertMessage = LocalizedString(
                    "lekaapp.settings_view.account_section.log_out.alert_message",
                    value: """
                        Are you sure you want to log out?
                        You will need to enter your email and password to log back in.
                        """,
                    comment: "Log out alert message"
                )

                static let alertButtonLabel = LocalizedString(
                    "lekaapp.settings_view.account_section.log_out.alert_button_label",
                    value: "Log out",
                    comment: "Log out alert button label"
                )

                static let errorAlertTitle = LocalizedString(
                    "lekaapp.settings_view.account_section.log_out.error_alert_title",
                    value: "Logout Error",
                    comment: "Log out error alert title"
                )

                static let errorAlertMessage = LocalizedString(
                    "lekaapp.settings_view.account_section.log_out.error_alert_message",
                    value: """
                        We encountered an issue logging you out. Please try again.
                        If the problem persists, contact our support team for assistance.
                        """,
                    comment: "Log out error alert message"
                )
            }

            enum DeleteAccount {
                static let buttonLabel = LocalizedString(
                    "lekaapp.settings_view.account_section.delete_account.button_label",
                    value: "Delete Account",
                    comment: "Delete account button label"
                )

                static let alertTitle = LocalizedString(
                    "lekaapp.settings_view.account_section.delete_account.alert_title",
                    value: "Delete Account?",
                    comment: "Account deletion alert title"
                )

                static let alertMessage = LocalizedString(
                    "lekaapp.settings_view.account_section.delete_account.alert_message",
                    value: """
                        Are you certain you want to delete your account?
                        This action cannot be undone.
                        """,
                    comment: "Account deletion alert message"
                )

                static let alertCancelButtonLabel = LocalizedString(
                    "lekaapp.settings_view.account_section.delete_account.alert_cancel_button_label",
                    value: "Cancel",
                    comment: "Delete account cancel button label"
                )

                static let alertDeleteButtonLabel = LocalizedString(
                    "lekaapp.settings_view.account_section.delete_account.alert_delete_button_label",
                    value: "Delete",
                    comment: "Delete account delete button label"
                )

                static let errorAlertTitle = LocalizedString(
                    "lekaapp.settings_view.account_section.delete_account.error_alert_title",
                    value: "Account Deletion Error",
                    comment: "Account deletion error alert title"
                )

                static let errorAlertMessage = LocalizedString(
                    "lekaapp.settings_view.account_section.delete_account.error_alert_message",
                    value: """
                        We encountered an issue deleting your account. Please try again.
                        If the problem persists, contact our support team for assistance.
                        """,
                    comment: "Account deletion error alert message"
                )
            }

            enum LogInSignUp {
                static let buttonLabel = LocalizedString(
                    "lekaapp.settings_view.account_section.log_in_sign_up.button_label",
                    value: "Log In / Sign Up",
                    comment: "Log in / Sign up button label"
                )
            }
        }

        enum ProfilesSection {
            static let buttonLabel = LocalizedString(
                "lekaapp.settings_view.profiles_section.button_label",
                value: "Switch Caregiver Profile",
                comment: "Switch caregiver profile button label"
            )
        }

        enum AppUpdateSection {
            static let title = LocalizedString(
                "lekaapp.settings_view.app_update_section.title",
                value: "A new update is available!",
                comment: "Update app section title"
            )

            static let buttonLabel = LocalizedString(
                "lekaapp.settings_view.app_update_section.button_label",
                value: "Update now",
                comment: "Update app button label"
            )
        }

        enum ChangeLanguageSection {
            static let buttonLabel = LocalizedString(
                "lekaapp.settings_view.change_language_section.button_label",
                value: "Change App Language",
                comment: "Change app language button label"
            )
        }

        static let navigationTitle = LocalizedString(
            "lekaapp.settings_view.navigation_title",
            value: "Settings",
            comment: "The navigation title of Settings View"
        )

        static let closeButtonLabel = LocalizedString(
            "lekaapp.settings_view.close_button_label",
            value: "Close",
            comment: "Close button label of Settings View"
        )
    }
}

// swiftlint:enable nesting
