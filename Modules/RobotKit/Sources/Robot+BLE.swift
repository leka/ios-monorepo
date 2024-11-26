// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
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

                self.subscribeToConnectedPeripheralFullyInitialized()
            }
            .store(in: &cancellables)

        BLEManager.shared.didDisconnect
            .receive(on: DispatchQueue.main)
            .sink {
                self.connectedPeripheral = nil
                self.isConnected.send(false)

                AnalyticsManager.logEventRobotDisconnect(
                    robotName: self.name.value,
                    serialNumber: self.serialNumber.value,
                    osVersion: self.osVersion.value?.description ?? "(n/a)",
                    isCharging: self.isCharging.value,
                    batteryLevel: self.battery.value
                )
                AnalyticsManager.setUserPropertyUserRobotIsConnected(value: false)
            }
            .store(in: &cancellables)
    }

    private func subscribeToConnectedPeripheralFullyInitialized() {
        Just(())
            .combineLatest(self.name)
            .combineLatest(self.osVersion).dropFirst()
            .combineLatest(self.serialNumber).dropFirst()
            .combineLatest(self.isCharging).dropFirst()
            .combineLatest(self.battery).dropFirst()
            .combineLatest(self.negotiatedMTU).dropFirst()
            .first()
            .sink { [weak self] _ in
                guard let self else { return }

                AnalyticsManager.logEventRobotConnect(
                    robotName: self.name.value,
                    serialNumber: self.serialNumber.value,
                    osVersion: self.osVersion.value?.description ?? "0.0.0",
                    isCharging: self.isCharging.value,
                    batteryLevel: self.battery.value
                )
                AnalyticsManager.setUserPropertyUserRobotIsConnected(value: true)
            }
            .store(in: &self.cancellables)
    }
}
