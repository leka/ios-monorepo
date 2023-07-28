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

    public func copy(from robot: RobotPeripheralViewModel) {
        self.name = robot.name
        self.battery = robot.battery
        self.isCharging = robot.isCharging
        self.osVersion = robot.osVersion

        self.robotPeripheral = robot.robotPeripheral
    }

    public func subscribeToCharacteristicsNotifications() {
        self.registerBatteryCharacteristicNotificationCallback()
        self.registerChargingStatusNotificationCallback()

        self.robotPeripheral?.discoverAndListenForUpdates()
    }

    public func readReadOnlyCharacteristics() {
        self.registerOSVersionReadCallback()
        self.registerSerialNumberReadCallback()

        self.robotPeripheral?.readReadOnlyCharacteristics()
    }

    private func registerBatteryCharacteristicNotificationCallback() {
        var characteristic = NotifyingCharacteristic(
            characteristicUUID: BLESpecs.Battery.Characteristics.level,
            serviceUUID: BLESpecs.Battery.service
        )

        characteristic.onNotification = { data in
            if let value = data?.first {
                self.battery = Int(value)
            }
        }

        self.robotPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    private func registerChargingStatusNotificationCallback() {
        var characteristic = NotifyingCharacteristic(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.chargingStatus,
            serviceUUID: BLESpecs.Monitoring.service
        )

        characteristic.onNotification = { data in
            if let value = data?.first {
                self.isCharging = value == 1
            }
        }

        self.robotPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    private func registerOSVersionReadCallback() {
        var characteristic = ReadOnlyCharacteristic(
            characteristicUUID: BLESpecs.DeviceInformation.Characteristics.osVersion,
            serviceUUID: BLESpecs.DeviceInformation.service
        )

        characteristic.onRead = { data in
            if let data = data {
                self.osVersion = String(decoding: data, as: UTF8.self)
                    .replacingOccurrences(of: "\0", with: "")
            }
        }

        self.robotPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

    private func registerSerialNumberReadCallback() {
        var characteristic = ReadOnlyCharacteristic(
            characteristicUUID: BLESpecs.DeviceInformation.Characteristics.serialNumber,
            serviceUUID: BLESpecs.DeviceInformation.service
        )

        characteristic.onRead = { data in
            if let data = data {
                self.serialNumber = String(decoding: data, as: UTF8.self)
                    .replacingOccurrences(of: "\0", with: "")
            }
        }

        self.robotPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

}
