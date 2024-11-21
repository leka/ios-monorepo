// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Version

extension Robot {
    func registerBatteryCharacteristicNotificationCallback() {
        let characteristic = CharacteristicModelNotifying(
            characteristicUUID: BLESpecs.Battery.Characteristics.level,
            serviceUUID: BLESpecs.Battery.service,
            onNotification: { data in
                if let value = data?.first {
                    self.battery.send(Int(value))
                    log.trace("🤖 battery: \(self.battery.value)%")
                }
            }
        )

        connectedPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    func registerChargingStatusNotificationCallback() {
        let characteristic = CharacteristicModelNotifying(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.chargingStatus,
            serviceUUID: BLESpecs.Monitoring.service,
            onNotification: { data in
                if let value = data?.first {
                    self.isCharging.send(value == 1)
                    log.trace("🤖 isCharging: \(self.isCharging.value)")
                }
            }
        )

        connectedPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    func registerNegotiatedMTUNotificationCallback() {
        let characteristic = CharacteristicModelNotifying(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.negotiatedMTU,
            serviceUUID: BLESpecs.Monitoring.service,
            onNotification: { data in
                if let data {
                    self.negotiatedMTU.send(Int(data.map { UInt16($0) }.reduce(0) { $0 << 8 + $1 }))
                    log.trace("🤖 negotiated MTU: \(self.negotiatedMTU.value)")
                }
            }
        )

        connectedPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    func registerOSVersionReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.DeviceInformation.Characteristics.osVersion,
            serviceUUID: BLESpecs.DeviceInformation.service,
            onRead: { data in
                if let data {
                    self.osVersion.send(
                        Version(
                            String(decoding: data, as: UTF8.self)
                                .replacingOccurrences(of: "\0", with: "")))
                    log.trace("🤖 osVersion: \(self.osVersion.value)")
                }
            }
        )

        connectedPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

    func registerSerialNumberReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.DeviceInformation.Characteristics.serialNumber,
            serviceUUID: BLESpecs.DeviceInformation.service,
            onRead: { data in
                if let data {
                    self.serialNumber.send(
                        String(decoding: data, as: UTF8.self)
                            .replacingOccurrences(of: "\0", with: ""))
                    log.trace("🤖 serialNumber: \(self.serialNumber.value)")
                }
            }
        )

        connectedPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

    func registerChargingStatusReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.chargingStatus,
            serviceUUID: BLESpecs.Monitoring.service,
            onRead: { data in
                if let value = data?.first {
                    self.isCharging.send(value == 1)
                    log.trace("🤖 isCharging: \(self.isCharging.value)")
                }
            }
        )

        connectedPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }

    func registerNegotiatedMTUReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.negotiatedMTU,
            serviceUUID: BLESpecs.Monitoring.service,
            onRead: { data in
                if let data {
                    self.negotiatedMTU.send(Int(data.map { UInt16($0) }.reduce(0) { $0 << 8 + $1 }))
                    log.trace("🤖 negotiated MTU: \(self.negotiatedMTU.value)")
                }
            }
        )

        connectedPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }
}
