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

    static func logEventRobotConnect(
        robotName: String,
        serialNumber: String,
        osVersion: String,
        isCharging: Bool,
        batteryLevel: Int,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_robot_name": robotName,
            "lk_serial_number": serialNumber,
            "lk_os_version": osVersion,
            "lk_is_charging": isCharging,
            "lk_battery_level": batteryLevel,
        ].merging(parameters) { _, new in new }

        Self.logEvent(name: RobotEvent.connect.rawValue, parameters: params)
    }

    static func logEventRobotDisconnect(
        robotName: String,
        serialNumber: String,
        osVersion: String,
        isCharging: Bool,
        batteryLevel: Int,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_robot_name": robotName,
            "lk_serial_number": serialNumber,
            "lk_os_version": osVersion,
            "lk_is_charging": isCharging,
            "lk_battery_level": batteryLevel,
        ].merging(parameters) { _, new in new }

        Self.logEvent(name: RobotEvent.disconnect.rawValue, parameters: params)
    }

    // swiftlint:disable:next function_parameter_count
    static func logEventRobotRename(
        previousName: String,
        newName: String,
        serialNumber: String,
        osVersion: String,
        isCharging: Bool,
        batteryLevel: Int,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_previous_name": previousName,
            "lk_robot_name": newName,
            "lk_serial_number": serialNumber,
            "lk_os_version": osVersion,
            "lk_is_charging": isCharging,
            "lk_battery_level": batteryLevel,
        ].merging(parameters) { _, new in new }

        Self.logEvent(name: RobotEvent.rename.rawValue, parameters: params)
    }
}
