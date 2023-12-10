// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct CharacteristicModelWriteOnly {
    // MARK: Lifecycle

    public init(characteristicUUID: CBUUID, serviceUUID: CBUUID, onWrite: Callback? = nil) {
        self.characteristicUUID = characteristicUUID
        self.serviceUUID = serviceUUID
        self.onWrite = onWrite
    }

    // MARK: Public

    public typealias Callback = () -> Void

    public let characteristicUUID: CBUUID
    public let serviceUUID: CBUUID
    public let onWrite: Callback?
}
