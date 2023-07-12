// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Foundation

public class RobotPeripheralViewModel: ObservableObject {
    @Published var name: String
    @Published var serialNumber: String?
    @Published var battery: Int
    @Published var isCharging: Bool
    @Published var osVersion: String

    public var robotPeripheral: RobotPeripheral?

    init(
        name: String = "Leka", serialNumber: String? = nil, battery: Int? = nil, isCharging: Bool? = nil,
        osVersion: String = "1.2.3"
    ) {
        self.name = name
        self.serialNumber = serialNumber
        self.battery = battery ?? Int.random(in: 0...100)
        self.isCharging = isCharging ?? Bool.random()
        self.osVersion = osVersion
    }

    init(robotDiscovery: RobotDiscovery) {
        self.name = robotDiscovery.advertisingData.name
        self.battery = robotDiscovery.advertisingData.battery
        self.isCharging = robotDiscovery.advertisingData.isCharging
        self.osVersion = robotDiscovery.advertisingData.osVersion

        self.robotPeripheral = robotDiscovery.robotPeripheral
    }

    public func subscribeToCharacteristicsNotifications() {

        self.robotPeripheral?.discoverAndListenForUpdates()

        // TODO: Get OS Version & Serial Number
    }
}
