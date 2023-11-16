// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting

extension l10n {
    enum RobotKit {
        enum RobotConnectionView {
            static let navigationTitle = LocalizedString(
                "robotkit.robot_connect_view.navigation_title", value: "Connect to a robot",
                comment: "The title of the robot connection view"
            )

            static let searchingViewText = LocalizedString(
                "robotkit.robot_connect_view.searching_view_text", value: "Searching for robots...",
                comment: "The text displayed in the searching view"
            )

            static let cancelButton = LocalizedString(
                "robotkit.robot_connect_view.cancel_button", value: "Cancel",
                comment: "The title of the cancel button in the toolbar"
            )

            static let connectButton = LocalizedString(
                "robotkit.robot_connect_view.connect_button", value: "Connect",
                comment: "The title of the connect button"
            )

            static let disconnectButton = LocalizedString(
                "robotkit.robot_connect_view.disconnect_button", value: "Disconnect",
                comment: "The title of the disconnect button"
            )

            static let continueButton = LocalizedString(
                "robotkit.robot_connect_view.continue_button", value: "Continue",
                comment: "The title of the continue button"
            )
        }
    }
}

// swiftlint:enable nesting
