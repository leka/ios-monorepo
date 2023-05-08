// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct RobotDiscovery: Identifiable, Equatable {

    // MARK: - Public variables

    public let robotPeripheral: RobotPeripheral
    public var advertisingData: RobotAdvertisingData
    public let rssi: Double?

    // MARK: - Public functions

    public init(robotPeripheral: RobotPeripheral, advertisingData: RobotAdvertisingData, rssi: Double?) {
        self.robotPeripheral = robotPeripheral
        self.advertisingData = advertisingData
        self.rssi = rssi
    }

    // MARK: - Identifiable conformance

    public var id: UUID {
        robotPeripheral.peripheral.id
    }

    // MARK: - Equatable conformance

    public static func == (lhs: RobotDiscovery, rhs: RobotDiscovery) -> Bool {
        return lhs.robotPeripheral.peripheral.id == rhs.robotPeripheral.peripheral.id
    }

    public static func == (lhs: RobotDiscovery, rhs: RobotDiscovery?) -> Bool {
        guard let rhs = rhs else {
            return false
        }

        return lhs.robotPeripheral.peripheral.id == rhs.robotPeripheral.peripheral.id
    }

    public static func == (lhs: RobotDiscovery?, rhs: RobotDiscovery) -> Bool {
        guard let lhs = lhs else {
            return false
        }

        return lhs.robotPeripheral.peripheral.id == rhs.robotPeripheral.peripheral.id
    }
}
