// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Foundation

public class RobotManager: ObservableObject {
    @Published var robotPeripheral: RobotPeripheral?

    @Published var name: String?
    @Published var serialNumber: String?
    @Published var battery: Int?
    @Published var isCharging: Bool?
    @Published var osVersion: String?

    init(
        robotPeripheral: RobotPeripheral? = nil, name: String? = nil, serialNumber: String? = nil, battery: Int? = nil,
        isCharging: Bool? = nil,
        osVersion: String? = nil
    ) {
        self.robotPeripheral = robotPeripheral

        self.name = name
        self.serialNumber = serialNumber
        self.battery = battery
        self.isCharging = isCharging
        self.osVersion = osVersion

    }

    func setRobotPeripheral(from robotDiscovery: RobotDiscovery) {
        self.robotPeripheral = robotDiscovery.robotPeripheral

        self.name = robotDiscovery.advertisingData.name
        self.battery = robotDiscovery.advertisingData.battery
        self.isCharging = robotDiscovery.advertisingData.isCharging
        self.osVersion = robotDiscovery.advertisingData.osVersion

    }

    public func subscribeToCharacteristicsNotifications() {
        self.registerBatteryCharacteristicNotificationCallback()
        self.registerChargingStatusNotificationCallback()

        self.robotPeripheral?.discoverAndListenForUpdates()
    }

    public func readReadOnlyCharacteristics() {
        self.registerOSVersionReadCallback()
        self.registerSerialNumberReadCallback()
        self.registerChargingStatusReadCallback()

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

    private func registerChargingStatusReadCallback() {
        var characteristic = ReadOnlyCharacteristic(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.chargingStatus,
            serviceUUID: BLESpecs.Monitoring.service
        )

        characteristic.onRead = { data in
            if let value = data?.first {
                self.isCharging = value == 1
            }
        }

        self.robotPeripheral?.readOnlyCharacteristics.insert(characteristic)
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
