// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct CharacteristicModelReadOnly {
    public typealias Callback = ((_ data: Data?) -> Void)

    public let characteristicUUID: CBUUID
    public let serviceUUID: CBUUID
    public let onRead: Callback?

    public init(characteristicUUID: CBUUID, serviceUUID: CBUUID, onRead: Callback? = nil) {
        self.characteristicUUID = characteristicUUID
        self.serviceUUID = serviceUUID
        self.onRead = onRead
    }
}

extension CharacteristicModelReadOnly: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(characteristicUUID)
        hasher.combine(serviceUUID)
    }

    public static func == (lhs: CharacteristicModelReadOnly, rhs: CharacteristicModelReadOnly) -> Bool {
        lhs.serviceUUID == rhs.serviceUUID && lhs.characteristicUUID == rhs.characteristicUUID
    }
}

public let kDefaultReadOnlyCharacteristics: Set<CharacteristicModelReadOnly> = [
    CharacteristicModelReadOnly(
        characteristicUUID: BLESpecs.DeviceInformation.Characteristics.manufacturer,
        serviceUUID: BLESpecs.DeviceInformation.service
    ),
    CharacteristicModelReadOnly(
        characteristicUUID: BLESpecs.DeviceInformation.Characteristics.modelNumber,
        serviceUUID: BLESpecs.DeviceInformation.service
    ),
    CharacteristicModelReadOnly(
        characteristicUUID: BLESpecs.DeviceInformation.Characteristics.serialNumber,
        serviceUUID: BLESpecs.DeviceInformation.service
    ),
    CharacteristicModelReadOnly(
        characteristicUUID: BLESpecs.DeviceInformation.Characteristics.osVersion,
        serviceUUID: BLESpecs.DeviceInformation.service
    ),
]
