// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// swiftlint:disable type_name nesting line_length identifier_name
// swift-format-ignore
extension l10n {
    enum general {
        static let yes = LocalizedString("general.yes", value: "Yes", comment: "Yes")
        static let no = LocalizedString("general.no", value: "No", comment: "No")
    }

    enum main {
        static let appName = LocalizedString("main.app_name", value: "Leka Updater", comment: "Name of the application")
        static let appDescription = LocalizedString(
            "main.app_description", value: "The app to update your Leka robots!",
            comment: "Description of the application"
        )
    }

    enum connection {
        static let newRobot = LocalizedString(
            "connection.new_robot", value: "Connect to your robot", comment: "Connect a robot button label"
        )
        static let anotherRobot = LocalizedString("connection.another_robot", value: "Disconnect and connect another robot", comment: "Connect another robot button label")
    }

    enum information {
        enum status {
            static let robotNotConnected = LocalizedString(
                "information.status.robot_not_connected",
                value: "🤖 No robot connected 🚫",
                comment: "Robot not connected text"
            )
            static let robotCannotBeUpdatedText = LocalizedString(
                "information.status.robot_cannot_be_updated_text",
                value: "⚠️ DEV 🚧\nUpdate process not recognized or not available\n(Error code: #0003)",
                comment: "Robot cannot be updated text"
            )
            static let robotUpdateAvailable = LocalizedString(
                "information.status.robot_update_available", value: "⬆️ New firmware update available 📦",
                comment: "Robot firmware update available text"
            )
            static let robotIsUpToDate = LocalizedString(
                "information.status.robot_is_up_to_date", value: "🤖 Your robot is up-to-date! 🎉 You're all done 👌",
                comment: "Robot is up to date text"
            )
        }

        enum robot {
            static var serialNumber = LocalizedStringInterpolation(
                "information.robot.serial_number", value: "Serial Number blablabla: %@",
                comment: "Connected robot serial number"
            )
            static let battery = LocalizedStringInterpolation(
                "information.robot.battery", value: "Battery: %@", comment: "Connected robot battery level"
            )
            static let version = LocalizedStringInterpolation(
                "information.robot.version", value: "Version: %@", comment: "Connected robot version"
            )
            static let isCharging = LocalizedStringInterpolation(
                "information.robot.charging_status", value: "Charging: %@", comment: "Connected robot charging status"
            )
        }

        static let changelogSectionTitle = LocalizedString(
            "information.changelog_section_title", value: "New features", comment: "Changelog section title of latest firmware update"
        )
        static let changelogDisclosureTitle = LocalizedString(
            "information.changelog_disclosure_title", value: "Changelog", comment: "Changelog disclosure title of latest firmware update"
        )
        static let changelogNotFoundText = LocalizedString(
            "information.changelog_not_found_text", value: "Changelog is not available",
            comment: "Changelog not found text"
        )

        static let startUpdateButton = LocalizedString("information.start_update_button", value: "Start robot update", comment: "Start update button")
    }

    enum update {
        enum requirements {
            static let instructionsText = LocalizedString(
                "update.requirements.instructions_text", value: "To start the update, make sure that:",
                comment: "Requirements before update"
            )
            static let chargingBasePluggedText = LocalizedString(
                "update.requirements.charging_base_plugged_text",
                value: "The robot is placed on its base and the base is connected to the mains",
                comment: "Base must be plugged"
            )
            static let chargingBaseGreenLEDText = LocalizedString(
                "update.requirements.charging_base_green_led_text",
                value: "The charging LED is green indicating the correct positioning on the base",
                comment: "Base green LED must be on"
            )
            static let robotBatteryMinimumLevelText = LocalizedString(
                "update.requirements.robot_battery_minimum_level_text",
                value: "The robot battery level is at least 30%", comment: "Robot battery level must be at least 30%"
            )
        }

        enum error {
            static let failedToLoadFileDescription = LocalizedString("update.error.failed_to_load_file", value: "Robot update file cannot be opened\n(Error code #0001)", comment: "Failed to load file")
            static let failedToLoadFileInstructions = LocalizedString("update.error.failed_to_load_file_instructions", value: "Please reinstall the app", comment: "Failed to load file instructions")

            static let robotNotUpToDateDescription = LocalizedString("update.error.robot_not_up_to_date", value: "Update failed\n(Error code #0002)", comment: "Robot not up to date")
            static let robotNotUpToDateInstructions = LocalizedString("update.error.robot_not_up_to_date_instructions", value: "Reconnect the robot and restart the process", comment: "Robot not up to date instructions")

            static let updateProcessNotAvailableDescription = LocalizedString("update.error.update_process_not_available", value: "Update process not recognized or not available\n(Error code #0003)", comment: "Update process not available")
            static let updateProcessNotAvailableInstructions = LocalizedString("update.error.update_process_not_available_instructions", value: "Please contact technical support", comment: "Update process not available instructions")

            static let robotUnexpectedDisconnectionDescription = LocalizedString("update.error.robot_unexpected_disconnection", value: "The robot has been disconnected\n(Error code #0004)", comment: "Robot unexpected disconnection")
            static let robotUnexpectedDisconnectionInstructions = LocalizedString("update.error.robot_unexpected_disconnection_instructions", value: "Restart the robot using the \"Emergency stop\" card,\nreconnect the robot and restart the process", comment: "Robot unexpected disconnection instructions")

            static let unknownErrorDescription = LocalizedString("update.error.unknown_error", value: "An unknown error has occurred\n(Error code #0000)", comment: "unknown error")
            static let unknownErrorInstructions = LocalizedString("update.error.unknown_error_instructions", value: "Please contact technical support", comment: "unknown error instructions")
        }

        enum alert {
            static let robotNotInChargeTitle = LocalizedString("information.status.alert.robot_not_in_charge", value: "⚠️ WARNING ⚡\nThe robot is no longer in charge", comment: "Robot not in charge alert")

            static let robotNotInChargeMessage = LocalizedString("information.status.alert.robot_not_in_charge_button", value: "Please put Leka back on its charging station and/or check it's plugged to a power outlet", comment: "Robot not in charge alert button")
        }

        enum sending {
            static let sendingTitle = LocalizedString("update.sending.title", value: "Sending update to the robot", comment: "Sending title")
            static let instructions = LocalizedString("update.sending.instruction", value: "Do not unplug your robot\nDo not remove it from its charging station\nDo not close the app", comment: "Sending instruction")
        }

        enum rebooting {
            static let rebootingTitle = LocalizedString("update.rebooting.title", value: "The update is being installed", comment: "Rebooting title")
            static let rebootingSubtitle = LocalizedString("update.rebooting.subtitle", value: "Your robot will reboot in a few minutes", comment: "Rebooting subtitle")
        }

        enum finished {
            static let updateAnotherRobotButton = LocalizedString("update.finished.update_another_robot_button", value: "Update another robot", comment: "Update another robot button")

            static let launchLekaAppButton = LocalizedString("update.finished.launch_leka_app_button", value: "Launch Leka App 🚀", comment: "Launch Leka App button")

            static let robotUpdatedSuccessfully = LocalizedString("update.finished.robot_updated_successfully", value: "Congrats! 🥳\nYour robot is now up-to-date 🎉", comment: "Robot updated successfully")
        }

        static let stepNumber = LocalizedStringInterpolation("update.step_number", value: "Step %@", comment: "Update step number")

        static let errorTitle = LocalizedString("update.error", value: "An error has occurred", comment: "Update error")
        static let errorDescription = LocalizedString("update.error_description", value: "Unknown error", comment: "Update error description")
        static let errorCallToAction = LocalizedString("update.error_call_to_action", value: "Contact technical support", comment: "Update error call to action")
        static let errorBackButtonTitle = LocalizedString("update.error_back_button", value: "Return to robot connection page", comment: "Update error back button")
    }
}

// swiftlint:enable type_name nesting line_length identifier_name
