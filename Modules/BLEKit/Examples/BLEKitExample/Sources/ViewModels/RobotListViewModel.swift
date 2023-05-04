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

    // MARK: - Published variables

    @Published var selectedRobotDiscovery: RobotDiscovery?
    @Published var connectedRobotDiscovery: RobotDiscovery?
    @Published var connectedRobotPeripheral: RobotPeripheral?
    @Published var availableRobots: [RobotDiscovery] = []
    @Published var isScanning: Bool = false

    // MARK: - Public functions

    public init(bleManager: BLEManager) {
        self.bleManager = bleManager
        subscribeToScanningStatus()
        subscribeToRobotDiscoveries()
        subscribeToRobotPeripheralConnection()
    }

    public func scanForPeripherals() {
        if !bleManager.isScanning {
            print("Start scanning")
            bleManager.searchForPeripherals()
        } else {
            print("Stop scanning")
            bleManager.stopSearching()
            selectedRobotDiscovery = nil
        }
    }

    public func connectToSelectedPeripheral() {
        guard let peripheral = selectedRobotDiscovery?.peripheralDiscovery, let name = selectedRobotDiscovery?.name
        else {
            return
        }
        print("Connecting to \(name)")
        bleManager.connect(peripheral)
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
            self.availableRobots = []
        }
    }

    // MARK: - Private functions

    internal init(availableRobots: [RobotDiscovery]) {
        self.bleManager = BLEManager.live()
        self.availableRobots = availableRobots
    }

    private func subscribeToScanningStatus() {
        bleManager.$isScanning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                self.isScanning = status
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotDiscoveries() {
        bleManager.$peripheralDiscoveries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] discoveries in
                guard let self = self else { return }
                self.availableRobots = discoveries.map { discovery in
                    RobotDiscovery(peripheralDiscovery: discovery)
                }
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotPeripheralConnection() {
        bleManager.$connectedPeripheral
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peripheral in
                guard let self = self, let peripheral = peripheral else {
                    self?.connectedRobotPeripheral = nil
                    return
                }
                self.connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
            }
            .store(in: &cancellables)
    }

}
