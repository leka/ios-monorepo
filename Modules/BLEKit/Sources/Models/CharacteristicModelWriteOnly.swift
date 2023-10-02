// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct CharacteristicModelWriteOnly {

    public let characteristicUUID: CBUUID
    public let serviceUUID: CBUUID
    public var onWrite: (() -> Void)?

    public init(characteristicUUID: CBUUID, serviceUUID: CBUUID) {
        self.characteristicUUID = characteristicUUID
        self.serviceUUID = serviceUUID
    }

}
