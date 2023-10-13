// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Foundation
import Version

public class RobotManager: ObservableObject {
    @Published var robotPeripheral: RobotPeripheral?

    @Published var name: String?
    @Published var serialNumber: String?
    @Published var battery: Int?
    @Published var isCharging: Bool?
    @Published var osVersion: String?
    @Published var sha256: String?

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
        self.sha256 = nil

    }

    func setRobotPeripheral(from robotDiscovery: RobotDiscoveryModel) {
        self.robotPeripheral = robotDiscovery.robotPeripheral

        self.name = robotDiscovery.name
        self.battery = robotDiscovery.battery
        self.isCharging = robotDiscovery.isCharging
        self.osVersion = robotDiscovery.osVersion
        self.sha256 = nil

    }

    private func isSHA256Compatible() -> Bool {

        let startingVersion = Version(1, 3, 0)

        guard let osVersionString = self.osVersion else {
            return false
        }

        guard let osVersion = Version(osVersionString) else {
            return false
        }

        return osVersion >= startingVersion

    }

    public func subscribeToCharacteristicsNotifications() {
        self.registerBatteryCharacteristicNotificationCallback()
        self.registerChargingStatusNotificationCallback()

        if isSHA256Compatible() {
            self.registerSHA256CharacteristicNotificationCallback()
        }

        self.robotPeripheral?.discoverAndListenForUpdates()
    }

    public func readReadOnlyCharacteristics() {
        self.registerOSVersionReadCallback()
        self.registerSerialNumberReadCallback()
        self.registerChargingStatusReadCallback()

        self.robotPeripheral?.readReadOnlyCharacteristics()
    }

    private func registerBatteryCharacteristicNotificationCallback() {
        let characteristic = CharacteristicModelNotifying(
            characteristicUUID: BLESpecs.Battery.Characteristics.level,
            serviceUUID: BLESpecs.Battery.service,
            onNotification: { data in
                if let value = data?.first {
                    self.battery = Int(value)
                }
            }
        )

        self.robotPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    private func registerSHA256CharacteristicNotificationCallback() {
        let characteristic = CharacteristicModelNotifying(
            characteristicUUID: BLESpecs.FileExchange.Characteristics.fileSHA256,
            serviceUUID: BLESpecs.FileExchange.service,
            onNotification: { data in
                if let data = data {
                    self.sha256 = data.map { String(format: "%02hhx", $0) }.joined()
                }
            }
        )

        self.robotPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    private func registerChargingStatusReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.chargingStatus,
            serviceUUID: BLESpecs.Monitoring.service,
            onRead: { data in
                if let value = data?.first {
                    self.isCharging = value == 1
                }
            }
        )

        self.robotPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

    private func registerChargingStatusNotificationCallback() {
        let characteristic = CharacteristicModelNotifying(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.chargingStatus,
            serviceUUID: BLESpecs.Monitoring.service,
            onNotification: { data in
                if let value = data?.first {
                    self.isCharging = value == 1
                }
            }
        )

        self.robotPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    private func registerOSVersionReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.DeviceInformation.Characteristics.osVersion,
            serviceUUID: BLESpecs.DeviceInformation.service,
            onRead: { data in
                if let data = data {
                    self.osVersion = String(decoding: data, as: UTF8.self)
                        .replacingOccurrences(of: "\0", with: "")
                }
            }
        )

        self.robotPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

    private func registerSerialNumberReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.DeviceInformation.Characteristics.serialNumber,
            serviceUUID: BLESpecs.DeviceInformation.service,
            onRead: { data in
                if let data = data {
                    self.serialNumber = String(decoding: data, as: UTF8.self)
                        .replacingOccurrences(of: "\0", with: "")
                }
            }
        )

        self.robotPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

}
