// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import CombineCoreBluetooth

public class RobotDiscovery: Identifiable, Equatable {

    // MARK: - Public variables

    public internal(set) var name: String
    public internal(set) var osVersion: String
    public internal(set) var battery: String
    public internal(set) var isCharging: Bool

    public let peripheralDiscovery: PeripheralDiscovery?

    // MARK: - Private variables

    internal let advertisingData: RobotAdvertisingData?

    // MARK: - Public functions

    public init(peripheralDiscovery: PeripheralDiscovery) {
        self.peripheralDiscovery = peripheralDiscovery
        self.advertisingData = RobotAdvertisingData(peripheralDiscovery.advertisementData)

        guard let advertisingData = advertisingData else {
            self.name = "⚠️ NO NAME"
            self.osVersion = "⚠️ NO OS VERSION"
            self.battery = "⚠️ NO BATTERY LEVEL"
            self.isCharging = false
            return
        }

        self.name = advertisingData.name
        self.osVersion = advertisingData.osVersion
        self.battery = "\(advertisingData.battery)%"
        self.isCharging = advertisingData.isCharging
    }

    // MARK: - Equatable conformance

    public static func == (lhs: RobotDiscovery, rhs: RobotDiscovery) -> Bool {
        lhs.peripheralDiscovery?.id == rhs.peripheralDiscovery?.id
    }

    // MARK: - Private functions

    internal init(name: String, osVersion: String, battery: Int, isCharging: Bool) {
        self.peripheralDiscovery = nil
        self.advertisingData = nil

        self.name = name
        self.osVersion = osVersion
        self.battery = "\(battery)%"
        self.isCharging = isCharging
    }

}
