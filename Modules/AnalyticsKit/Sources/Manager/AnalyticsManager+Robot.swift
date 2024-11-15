// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    enum RobotEvent: String {
        case connect = "robot_connect"
        case disconnect = "robot_disconnect"
        case rename = "robot_rename"
    }

    func logEventRobotConnect(
        robotName: String,
        serialNumber: String,
        osVersion: String,
        isCharging: Bool,
        batteryLevel: Int
    ) {
        Analytics.logEvent(RobotEvent.connect.rawValue, parameters: [
            "robot_name": robotName,
            "serial_number": serialNumber,
            "os_version": osVersion,
            "is_charging": isCharging,
            "battery_level": batteryLevel,
        ])
    }

    func logEventRobotDisconnect(
        robotName: String,
        serialNumber: String,
        osVersion: String,
        isCharging: Bool,
        batteryLevel: Int
    ) {
        Analytics.logEvent(RobotEvent.disconnect.rawValue, parameters: [
            "robot_name": robotName,
            "serial_number": serialNumber,
            "os_version": osVersion,
            "is_charging": isCharging,
            "battery_level": batteryLevel,
        ])
    }

    func logEventRobotRename(
        previousName: String,
        newName: String,
        serialNumber: String,
        osVersion: String,
        isCharging: Bool,
        batteryLevel: Int
    ) {
        Analytics.logEvent(RobotEvent.rename.rawValue, parameters: [
            "previous_name": previousName,
            "robot_name": newName,
            "serial_number": serialNumber,
            "os_version": osVersion,
            "is_charging": isCharging,
            "battery_level": batteryLevel,
        ])
    }
}
