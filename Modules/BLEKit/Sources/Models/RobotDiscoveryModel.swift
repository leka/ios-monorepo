// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

// MARK: - RobotDiscoveryModel

public struct RobotDiscoveryModel: Identifiable {
    // MARK: Lifecycle

    // MARK: - Public functions

    public init(name: String, isCharging: Bool, battery: Int, osVersion: String, isDeepSleeping: Bool = false) {
        self.robotPeripheral = nil
        self.rssi = nil
        self.id = UUID()
        self.name = name
        self.osVersion = osVersion
        self.battery = battery
        self.isCharging = isCharging
        self.isDeepSleeping = isDeepSleeping
    }

    public init(robotPeripheral: RobotPeripheral, advertisingData: RobotAdvertisingData?, rssi: Double?) {
        self.robotPeripheral = robotPeripheral
        self.rssi = rssi
        self.id = robotPeripheral.peripheral.id
        self.name = advertisingData.name
        self.osVersion = computeVersion(version: advertisingData.osVersion, name: advertisingData.name)
        self.battery = advertisingData.battery
        self.isCharging = advertisingData.isCharging
        self.isDeepSleeping = advertisingData.isDeepSleeping ?? false
    }

    // MARK: Public

    // MARK: - Public variables

    public let robotPeripheral: RobotPeripheral!
    public let rssi: Double?

    public let id: UUID
    public let name: String
    public let osVersion: String
    public let battery: Int
    public let isCharging: Bool
    public let isDeepSleeping: Bool
}

// MARK: Equatable

extension RobotDiscoveryModel: Equatable {
    public static func == (lhs: RobotDiscoveryModel, rhs: RobotDiscoveryModel) -> Bool {
        lhs.id == rhs.id
    }
}

private func computeVersion(version: String?, name: String) -> String {
    if let version {
        return "\(version)"
    }

    if name == "Leka" {
        return "1.0.0"
    } else if name.contains("LK-"), name.contains("xx") {
        return "1.1.0"
    } else if name.contains("LK-") {
        return "1.2.0"
    } else {
        return "(n/a)"
    }
}
