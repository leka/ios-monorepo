// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct ReadOnlyCharacteristic: Hashable {

    public let characteristicUUID: CBUUID
    public let serviceUUID: CBUUID
    public var onRead: ((_ data: Data?) -> Void)?

    public init(characteristicUUID: CBUUID, serviceUUID: CBUUID) {
        self.characteristicUUID = characteristicUUID
        self.serviceUUID = serviceUUID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(characteristicUUID)
        hasher.combine(serviceUUID)
    }

    public static func == (lhs: ReadOnlyCharacteristic, rhs: ReadOnlyCharacteristic) -> Bool {
        return lhs.serviceUUID == rhs.serviceUUID && lhs.characteristicUUID == rhs.characteristicUUID
    }

}

public let kDefaultReadOnlyCharacteristics: Set<ReadOnlyCharacteristic> = [
    ReadOnlyCharacteristic(
        characteristicUUID: BLESpecs.DeviceInformation.Characteristics.manufacturer,
        serviceUUID: BLESpecs.DeviceInformation.service
    ),
    ReadOnlyCharacteristic(
        characteristicUUID: BLESpecs.DeviceInformation.Characteristics.modelNumber,
        serviceUUID: BLESpecs.DeviceInformation.service
    ),
    ReadOnlyCharacteristic(
        characteristicUUID: BLESpecs.DeviceInformation.Characteristics.serialNumber,
        serviceUUID: BLESpecs.DeviceInformation.service
    ),
    ReadOnlyCharacteristic(
        characteristicUUID: BLESpecs.DeviceInformation.Characteristics.osVersion,
        serviceUUID: BLESpecs.DeviceInformation.service
    ),
]
