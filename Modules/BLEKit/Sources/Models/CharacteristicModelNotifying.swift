// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct CharacteristicModelNotifying: Hashable {

    public let characteristicUUID: CBUUID
    public let serviceUUID: CBUUID
    public var characteristic: CBCharacteristic?
    public var onNotification: ((_ data: Data?) -> Void)?

    public init(characteristicUUID: CBUUID, serviceUUID: CBUUID) {
        self.characteristicUUID = characteristicUUID
        self.serviceUUID = serviceUUID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(characteristicUUID)
        hasher.combine(serviceUUID)
    }

    public static func == (lhs: CharacteristicModelNotifying, rhs: CharacteristicModelNotifying) -> Bool {
        lhs.serviceUUID == rhs.serviceUUID && lhs.characteristicUUID == rhs.characteristicUUID
    }

}

public let kDefaultNotifyingCharacteristics: Set<CharacteristicModelNotifying> = [
    CharacteristicModelNotifying(
        characteristicUUID: BLESpecs.Battery.Characteristics.level,
        serviceUUID: BLESpecs.Battery.service
    ),
    CharacteristicModelNotifying(
        characteristicUUID: BLESpecs.Monitoring.Characteristics.chargingStatus,
        serviceUUID: BLESpecs.Monitoring.service
    ),
    CharacteristicModelNotifying(
        characteristicUUID: BLESpecs.MagicCard.Characteristics.id,
        serviceUUID: BLESpecs.MagicCard.service
    ),
    CharacteristicModelNotifying(
        characteristicUUID: BLESpecs.MagicCard.Characteristics.language,
        serviceUUID: BLESpecs.MagicCard.service
    ),
]
