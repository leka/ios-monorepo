// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Foundation

extension Robot {
    func subscribeToBLEConnectionUpdates() {
        BLEManager.shared.didConnect
            .receive(on: DispatchQueue.main)
            .sink {
                self.connectedPeripheral = $0
                self.isConnected.send(true)
                self.name.send($0.peripheral.name ?? "(n/a)")
            }
            .store(in: &cancellables)

        BLEManager.shared.didDisconnect
            .receive(on: DispatchQueue.main)
            .sink {
                self.connectedPeripheral = nil
                self.isConnected.send(false)
            }
            .store(in: &cancellables)
    }
}
