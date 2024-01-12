// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length

extension l10n {
    enum AccountCreationView {
        static let navigationTitle = LocalizedString("lekaapp.account_creation_view.navigation_title", value: "First connection", comment: "NavigationBar title on the whole Signup process")

        static let createAccountTitle = LocalizedString("lekaapp.account_creation_view.create_account_title", value: "Create an account", comment: "Create account title on SignupView")

        static let emailLabel = LocalizedString("lekaapp.account_creation_view.email_label", value: "Email", comment: "Email label on SignupView")

        static let passwordLabel = LocalizedString("lekaapp.account_creation_view.password_label", value: "Password", comment: "Password label on SignupView")

        static let confirmLabel = LocalizedString("lekaapp.account_creation_view.confirm_label", value: "Confirm Password", comment: "Confirm Password label on SignupView")

        static let connectionButton = LocalizedString("lekaapp.account_creation_view.connection_button", value: "Connection", comment: "Connection button on SignupView")

        static let step1Title = LocalizedString("lekaapp.account_creation_view.step_1_title",
                                                value: """
                                                    Congratulations ! 🎉
                                                    You have just created your Leka account!
                                                    """,
                                                comment: "Step 1 title")

        static let step1Message = LocalizedString("lekaapp.account_creation_view.step_1_message",
                                                  value: """
                                                      We will now discover the application
                                                      together. Are you ready?
                                                      """,
                                                  comment: "Step 1 message")

        static let step1GoButton = LocalizedString("lekaapp.account_creation_view.step_1_go_button", value: "👉 Here we go !", comment: "Step 1 let's go button")

        static let step2Title = LocalizedString("lekaapp.account_creation_view.step_2_title", value: "Step 1 :", comment: "Step 2 title")

        static let step2Message = LocalizedString("lekaapp.account_creation_view.step_2_message", value: "We will create your caregiver profile.", comment: "Step 2 message")

        static let step2CreateButton = LocalizedString("lekaapp.account_creation_view.step_2_create_button", value: "Create", comment: "Step 2 create button")

        static let step3Title = LocalizedString("lekaapp.account_creation_view.step_3_title", value: "Step 2 :", comment: "Step 3 title")

        static let step3Message = LocalizedString("lekaapp.account_creation_view.step_3_message",
                                                  value: """
                                                      We will now create your first
                                                      care receiver profile.
                                                      """,
                                                  comment: "Step 3 message")

        static let step3CreateButton = LocalizedString("lekaapp.account_creation_view.step_3_create_button", value: "Create", comment: "Step 3 create button")

        static let stepFinalTitle = LocalizedString("lekaapp.account_creation_view.step_final_title", value: "🎉 Congratulations again! 👏", comment: "Step final title")

        static let stepFinalMessage = LocalizedString("lekaapp.account_creation_view.step_final_message",
                                                      value: """
                                                          You have completed these 2 steps brilliantly:

                                                          ✅ Create your professional profile
                                                          ✅ Create your first supported person profile

                                                          You can now discover the Leka universe and our educational content.
                                                          """,
                                                      comment: "Step final message")

        static let stepFinalDiscoverContentButton = LocalizedString("lekaapp.account_creation_view.step_final_discover_content_button", value: "Discover content!", comment: "Step final discover content button")
    }
}

// swiftlint:enable line_length
