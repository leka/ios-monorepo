// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length nesting

extension l10n {
    enum SettingsView {
        enum AppearanceSection {
            enum AppearanceRow {
                static let title = LocalizedString("settings_view.appearance_section.appearance_row.title", value: "Dark mode", comment: "Appearance Row title")
            }

            enum AccentColorRow {
                static let title = LocalizedString("settings_view.appearance_section.accent_color_row.title", value: "Accent Color", comment: "AccentColor Row title")
            }

            static let header = LocalizedString("settings_view.appearance_section.header", value: "Appearance", comment: "Appearance section header")
        }

        enum CredentialsSection {
            enum ChangeCredentials {
                static let buttonLabel = LocalizedString("settings_view.credentials_section.change_credentials.button_label", value: "Change email and password", comment: "Change credentials button label")

                static let alertTitle = LocalizedString("settings_view.credentials_section.change_credentials.alert_title",
                                                        value: "It is not yet possible to modify your email or password from the application.",
                                                        comment: "Change credentials alert title")

                static let alertMessage = LocalizedString("settings_view.credentials_section.change_credentials.alert_message",
                                                          value: """
                                                              Please send an email to hello@leka.io
                                                              to modify your credentials.
                                                              """,
                                                          comment: "Change credentials alert message")
            }

            static let header = LocalizedString("settings_view.credentials_section.header", value: "Credentials", comment: "Credentials section header")

            static let emailLabel = LocalizedString("settings_view.credentials_section.email_label", value: "Account email adress", comment: "Account email address label")
        }

        enum AccountSection {
            enum LogOut {
                static let buttonLabel = LocalizedString("settings_view.account_section.log_out.button_label", value: "Log out", comment: "Log out button label")

                static let alertTitle = LocalizedString("settings_view.account_section.log_out.alert_title", value: "Log out", comment: "Log out alert title")

                static let alertMessage = LocalizedString("settings_view.account_section.log_out.alert_message", value: "You are about to log out.", comment: "Log out alert message")

                static let alertButtonLabel = LocalizedString("settings_view.account_section.log_out.alert_buton_label", value: "Log out", comment: "Log out alert button label")
            }

            enum DeleteAccount {
                static let buttonLabel = LocalizedString("settings_view.account_section.delete_account.button_label", value: "Delete account", comment: "Delete account button label")

                static let alertTitle = LocalizedString("settings_view.account_section.delete_account.alert_title", value: "Delete account", comment: "Delete account alert title")

                static let alertMessage = LocalizedString("settings_view.account_section.delete_account.alert_message",
                                                          value: """
                                                              Please send an email to hello@leka.io
                                                              to delete your account.
                                                              """,
                                                          comment: "Delete account alert message")
            }
        }

        static let navigationTitle = LocalizedString("settings_view.navigation_title", value: "Settings", comment: "The navigation title of Settings View")

        static let closeButtonLabel = LocalizedString("settings_view.close_button_label", value: "Close", comment: "Close button label of Settings View")
    }
}

// swiftlint:enable line_length nesting
