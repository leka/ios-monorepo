// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine

extension Robot {

    func registerBatteryCharacteristicNotificationCallback() {
        let characteristic = CharacteristicModelNotifying(
            characteristicUUID: BLESpecs.Battery.Characteristics.level,
            serviceUUID: BLESpecs.Battery.service,
            onNotification: { data in
                if let value = data?.first {
                    self.battery.send(Int(value))
                    print("🤖 INFO - battery \(self.battery.value)")
                }
            }
        )

        self.connectedPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    func registerChargingStatusNotificationCallback() {
        let characteristic = CharacteristicModelNotifying(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.chargingStatus,
            serviceUUID: BLESpecs.Monitoring.service,
            onNotification: { data in
                if let value = data?.first {
                    self.isCharging.send(value == 1)
                    print("🤖 INFO - isCharging \(self.isCharging.value)")
                }
            }
        )

        self.connectedPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    func registerOSVersionReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.DeviceInformation.Characteristics.osVersion,
            serviceUUID: BLESpecs.DeviceInformation.service,
            onRead: { data in
                if let data = data {
                    self.osVersion.send(
                        String(decoding: data, as: UTF8.self)
                            .replacingOccurrences(of: "\0", with: ""))
                    print("🤖 INFO - osVersion \(self.osVersion.value)")
                }
            }
        )

        self.connectedPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

    func registerSerialNumberReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.DeviceInformation.Characteristics.serialNumber,
            serviceUUID: BLESpecs.DeviceInformation.service,
            onRead: { data in
                if let data = data {
                    self.serialNumber.send(
                        String(decoding: data, as: UTF8.self)
                            .replacingOccurrences(of: "\0", with: ""))
                    print("🤖 INFO - serialNumber \(self.serialNumber.value)")
                }
            }
        )

        self.connectedPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

}
