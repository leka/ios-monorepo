// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length nesting

extension l10n {
    enum AccountCreationProcess {
        enum Step1 {
            static let title = LocalizedString("lekaapp.account_creation_process.step_1.title",
                                               value: """
                                                   Welcome to our account creation process! 👋
                                                   """,
                                               comment: "Step 1 title")

            static let message = LocalizedString("lekaapp.account_creation_process.step_1.message",
                                                 value: """
                                                     We will now guide you throught
                                                     the creation of your account
                                                     and the different steps.
                                                     Ready?
                                                     """,
                                                 comment: "Step 1 message")

            static let goButton = LocalizedString("lekaapp.account_creation_process.step_1.go_button", value: "Let's start! 👉", comment: "Step 1 continue button")
        }

        enum Step2 {
            static let title = LocalizedString("lekaapp.account_creation_process.step_2.title", value: "Step 1 - Caregiver profile", comment: "Step 2 title")

            static let message = LocalizedString("lekaapp.account_creation_process.step_2.message", value: "First, let's create your profile as a caregiver.", comment: "Step 2 message")

            static let createButton = LocalizedString("lekaapp.account_creation_process.step_2.create_button", value: "Create", comment: "Step 2 create button")
        }

        enum Step3 {
            static let title = LocalizedString("lekaapp.account_creation_process.step_3.title", value: "Step 2 - Care receiver profile", comment: "Step 3 title")

            static let message = LocalizedString("lekaapp.account_creation_process.step_3.message",
                                                 value: """
                                                     We will now create your first
                                                     care receiver profile.
                                                     """,
                                                 comment: "Step 3 message")

            static let createButton = LocalizedString("lekaapp.account_creation_process.step_3.create_button", value: "Create", comment: "Step 3 create button")
        }

        enum Step4 {
            static let title = LocalizedString("lekaapp.account_creation_process.step_4.title", value: "🎉 Congratulations! 👏", comment: "Step 4 title")

            static let message = LocalizedString("lekaapp.account_creation_process.step_4.message",
                                                 value: """
                                                     You have just completed:

                                                     ✅ Your caregiver profile
                                                     ✅ Your first care receiver profile

                                                     You can now discover the Leka App and dive deep in our educational content!
                                                     """,
                                                 comment: "Step 4 message")

            static let discoverContentButton = LocalizedString("lekaapp.account_creation_process.step_4.discover_content_button", value: "Let's go! 🚀", comment: "Step 4 discover content button")
        }

        static let navigationTitle = LocalizedString("lekaapp.account_creation_process.navigation_title", value: "Account Creation Process", comment: "NavigationBar title on the whole Signup process")
    }
}

// swiftlint:enable line_length nesting
