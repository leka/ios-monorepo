// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

// MARK: - CharacteristicModelNotifying

public struct CharacteristicModelNotifying {
    // MARK: Lifecycle

    public init(
        characteristicUUID: CBUUID, serviceUUID: CBUUID, cbCharacteristic: CBCharacteristic? = nil,
        onNotification: Callback? = nil
    ) {
        self.characteristicUUID = characteristicUUID
        self.serviceUUID = serviceUUID
        self.cbCharacteristic = cbCharacteristic
        self.onNotification = onNotification
    }

    // MARK: Public

    public typealias Callback = (_ data: Data?) -> Void

    public let characteristicUUID: CBUUID
    public let serviceUUID: CBUUID
    public let cbCharacteristic: CBCharacteristic?
    public let onNotification: Callback?
}

// MARK: Hashable

extension CharacteristicModelNotifying: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.characteristicUUID)
        hasher.combine(self.serviceUUID)
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
]
