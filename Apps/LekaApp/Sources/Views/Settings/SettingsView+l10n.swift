// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length nesting

extension l10n {
    enum SettingsView {
        enum CredentialsSection {
            enum ChangeCredentials {
                static let buttonLabel = LocalizedString("lekaapp.settings_view.credentials_section.change_credentials.button_label", value: "Contact Support for Email/Password Change", comment: "Change credentials button label")

                static let alertTitle = LocalizedString("lekaapp.settings_view.credentials_section.change_credentials.alert_title",
                                                        value: "Need to Update Your Credentials?",
                                                        comment: "Change credentials alert title")

                static let alertMessage = LocalizedString("lekaapp.settings_view.credentials_section.change_credentials.alert_message",
                                                          value: """
                                                              For security reasons, changes to your email or password need to be handled by our support team.
                                                              Please contact us at
                                                              support@leka.io
                                                              and we'll be happy to assist you with updating your account information.
                                                              """,
                                                          comment: "Change credentials alert message")
            }

            static let emailLabel = LocalizedString("lekaapp.settings_view.credentials_section.email_label", value: "Account Email", comment: "Account email address label")
        }

        enum AccountSection {
            enum LogOut {
                static let alertTitle = LocalizedString("lekaapp.settings_view.account_section.log_out.alert_title", value: "Confirm Logout", comment: "Log out alert title")

                static let buttonLabel = LocalizedString("lekaapp.settings_view.account_section.log_out.button_label", value: "Log Out", comment: "Log out button label")

                static let alertMessage = LocalizedString("lekaapp.settings_view.account_section.log_out.alert_message",
                                                          value: """
                                                              Are you sure you want to log out?
                                                              You will need to enter your email and password to log back in.
                                                              """,
                                                          comment: "Log out alert message")

                static let alertButtonLabel = LocalizedString("lekaapp.settings_view.account_section.log_out.alert_button_label", value: "Log out", comment: "Log out alert button label")

                static let errorAlertTitle = LocalizedString("lekaapp.settings_view.account_section.log_out.error_alert_title", value: "Logout Error", comment: "Log out error alert title")

                static let errorAlertMessage = LocalizedString("lekaapp.settings_view.account_section.log_out.error_alert_message",
                                                               value: """
                                                                   We encountered an issue logging you out. Please try again.
                                                                   If the problem persists, contact our support team for assistance.
                                                                   """,
                                                               comment: "Log out error alert message")
            }

            enum DeleteAccount {
                static let buttonLabel = LocalizedString("lekaapp.settings_view.account_section.delete_account.button_label", value: "Delete Account", comment: "Delete account button label")

                static let alertTitle = LocalizedString("lekaapp.settings_view.account_section.delete_account.alert_title", value: "Delete Account?", comment: "Account deletion alert title")

                static let alertMessage = LocalizedString("lekaapp.settings_view.account_section.delete_account.alert_message",
                                                          value: """
                                                              Are you certain you want to delete your account?
                                                              This action cannot be undone.
                                                              """,
                                                          comment: "Account deletion alert message")

                static let alertCancelButtonLabel = LocalizedString("lekaapp.settings_view.account_section.delete_account.alert_cancel_button_label", value: "Cancel", comment: "Delete account cancel button label")

                static let alertDeleteButtonLabel = LocalizedString("lekaapp.settings_view.account_section.delete_account.alert_delete_button_label", value: "Delete", comment: "Delete account delete button label")

                static let errorAlertTitle = LocalizedString("lekaapp.settings_view.account_section.delete_account.error_alert_title", value: "Account Deletion Error", comment: "Account deletion error alert title")

                static let errorAlertMessage = LocalizedString("lekaapp.settings_view.account_section.delete_account.error_alert_message",
                                                               value: """
                                                                   We encountered an issue deleting your account. Please try again.
                                                                   If the problem persists, contact our support team for assistance.
                                                                   """,
                                                               comment: "Account deletion error alert message")
            }
        }

        enum ProfilesSection {
            static let buttonLabel = LocalizedString("lekaapp.settings_view.profiles_section.button_label", value: "Switch Caregiver Profile", comment: "Switch caregiver profile button label")
        }

        enum ChangeLanguageSection {
            static let buttonLabel = LocalizedString("lekaapp.settings_view.change_language_section.button_label", value: "Change App Language", comment: "Change app language button label")
        }

        static let navigationTitle = LocalizedString("lekaapp.settings_view.navigation_title", value: "Settings", comment: "The navigation title of Settings View")

        static let closeButtonLabel = LocalizedString("lekaapp.settings_view.close_button_label", value: "Close", comment: "Close button label of Settings View")
    }
}

// swiftlint:enable line_length nesting
