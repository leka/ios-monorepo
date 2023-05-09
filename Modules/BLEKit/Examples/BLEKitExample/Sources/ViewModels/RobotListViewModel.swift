// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import SwiftUI

@MainActor
public class RobotListViewModel: ObservableObject {

    // MARK: - Private variables

    internal let bleManager: BLEManager
    internal var cancellables: Set<AnyCancellable> = []
    internal var scanForRobotsTask: AnyCancellable?

    // MARK: - Published variables

    @Published var selectedRobotDiscovery: RobotDiscovery?
    @Published var connectedRobotDiscovery: RobotDiscovery?
    @Published var connectedRobotPeripheral: RobotPeripheral?
    @Published var robotDiscoveries: [RobotDiscovery] = []
    @Published var isScanning: Bool = false

    // MARK: - Public functions

    public init(bleManager: BLEManager) {
        self.bleManager = bleManager
        subscribeToScanningStatus()
        subscribeToRobotPeripheralConnection()
    }

    public func scanForPeripherals() {
        if !bleManager.isScanning.value {
            print("Start scanning")
            scanForRobotsTask = bleManager.scanForRobots()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { error in
                        print("💥 ERROR: \(error)")
                    },
                    receiveValue: { robotDiscoveries in
                        self.robotDiscoveries = robotDiscoveries
                    }
                )
        } else {
            print("Stop scanning")
            robotDiscoveries = []
            scanForRobotsTask?.cancel()
            selectedRobotDiscovery = nil
        }
    }

    public func connectToSelectedPeripheral() {
        guard let selectedRobotDiscovery = selectedRobotDiscovery else { return }
        print("Connecting to \(selectedRobotDiscovery.advertisingData.name)")
        bleManager.connect(selectedRobotDiscovery)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    // nothing to do
                },
                receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    self.connectedRobotDiscovery = self.selectedRobotDiscovery
                }
            )
            .store(in: &cancellables)
    }

    public func disconnectFromConnectedPeripheral() {
        print("Disconnecting")
        bleManager.disconnect()
        self.connectedRobotDiscovery = nil
        if !isScanning {
            self.robotDiscoveries = []
        }
    }

    // MARK: - Private functions

    internal init(availableRobots: [RobotDiscovery]) {
        self.bleManager = BLEManager.live()
        self.robotDiscoveries = availableRobots
    }

    private func subscribeToScanningStatus() {
        bleManager.isScanning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                self.isScanning = status
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotPeripheralConnection() {
        bleManager.$connectedRobotPeripheral
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connectedRobotPeripheral in
                guard let self = self, let connectedRobotPeripheral = connectedRobotPeripheral else {
                    self?.connectedRobotPeripheral = nil
                    return
                }
                self.connectedRobotPeripheral = connectedRobotPeripheral
            }
            .store(in: &cancellables)
    }

}
