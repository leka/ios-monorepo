// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct RobotDiscoveryModel: Identifiable {

    // MARK: - Public variables

    public let robotPeripheral: RobotPeripheral
    public let rssi: Double?

    public let id: UUID
    public let name: String
    public let isCharging: Bool
    public let battery: Int
    public let osVersion: String

    // MARK: - Public functions

    public init(robotPeripheral: RobotPeripheral, advertisingData: RobotAdvertisingData, rssi: Double?) {
        self.robotPeripheral = robotPeripheral
        self.rssi = rssi
        self.id = robotPeripheral.peripheral.id
        self.name = advertisingData.name
        self.isCharging = advertisingData.isCharging
        self.battery = advertisingData.battery
        self.osVersion = computeVersion(version: advertisingData.osVersion, name: advertisingData.name)
    }

}

extension RobotDiscoveryModel: Equatable {

    public static func == (lhs: RobotDiscoveryModel, rhs: RobotDiscoveryModel) -> Bool {
        lhs.id == rhs.id
    }

}

private func computeVersion(version: String?, name: String) -> String {
    if let version = version {
        return "v\(version)"
    }

    if name == "Leka" {
        return "v1.0.0"
    } else if name.contains("LK-") && name.contains("xx") {
        return "v1.1.0"
    } else if name.contains("LK-") {
        return "v1.2.0"
    } else {
        return "(n/a)"
    }
}
