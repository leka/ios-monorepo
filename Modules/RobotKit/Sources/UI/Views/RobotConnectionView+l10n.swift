// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting

extension l10n {
    enum RobotKit {
        enum RobotConnectionView {
            static let navigationTitle = LocalizedString(
                "robotkit.robot_connect_view.navigation_title",
                bundle: RobotKitResources.bundle,
                value: "Connect to a robot",
                comment: "The title of the robot connection view"
            )

            static let searchingViewText = LocalizedString(
                "robotkit.robot_connect_view.searching_view_text",
                bundle: RobotKitResources.bundle,
                value: "Searching for robots...",
                comment: "The text displayed in the searching view"
            )

            static let closeButton = LocalizedString(
                "robotkit.robot_connect_view.close_button",
                bundle: RobotKitResources.bundle,
                value: "Close",
                comment: "The title of the close button in the toolbar"
            )

            static let connectButton = LocalizedString(
                "robotkit.robot_connect_view.connect_button",
                bundle: RobotKitResources.bundle,
                value: "Connect",
                comment: "The title of the connect button"
            )

            static let disconnectButton = LocalizedString(
                "robotkit.robot_connect_view.disconnect_button",
                bundle: RobotKitResources.bundle,
                value: "Disconnect",
                comment: "The title of the disconnect button"
            )

            static let continueButton = LocalizedString(
                "robotkit.robot_connect_view.continue_button",
                bundle: RobotKitResources.bundle,
                value: "Continue",
                comment: "The title of the continue button"
            )

            static let updateButton = LocalizedString(
                "robotkit.robot_connect_view.update_button",
                bundle: RobotKitResources.bundle,
                value: "Update",
                comment: "The title of the update button"
            )
        }
    }
}

// swiftlint:enable nesting
