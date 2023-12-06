// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import SwiftUI

@MainActor
public class RobotListViewModel: ObservableObject {
    // MARK: Lifecycle

    // MARK: - Public functions

    public init(bleManager: BLEManager) {
        self.bleManager = bleManager
        subscribeToScanningStatus()
    }

    // MARK: - Private functions

    init(availableRobots: [RobotDiscoveryModel]) {
        self.bleManager = BLEManager.live()
        self.robotDiscoveries = availableRobots
    }

    // MARK: Public

    public func scanForPeripherals() {
        if !bleManager.isScanning.value {
            print("Start scanning")
            scanForRobotsTask = bleManager.scanForRobots()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            print("💥 ERROR: \(error)")
                        }
                    },
                    receiveValue: { robotDiscoveries in
                        self.robotDiscoveries = robotDiscoveries
                    }
                )
        } else {
            print("Stop scanning")
            // TODO(@ladislas): do not reset to try and connect --> handle errors for real
            robotDiscoveries = []
            scanForRobotsTask?.cancel()
            selectedRobotDiscovery = nil
        }
    }

    public func connectToSelectedPeripheral() {
        guard let selectedRobotDiscovery else { return }
        print("Connecting to \(selectedRobotDiscovery.name)")
        bleManager.connect(selectedRobotDiscovery)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("💥 ERROR: \(error)")
                    }
                },
                receiveValue: { [weak self] connectedRobotPeripheral in
                    guard let self else { return }
                    self.connectedRobotDiscovery = self.selectedRobotDiscovery
                    self.connectedRobotPeripheral = connectedRobotPeripheral
                }
            )
            .store(in: &cancellables)
    }

    public func disconnectFromConnectedPeripheral() {
        print("Disconnecting")
        bleManager.disconnect()
        self.connectedRobotDiscovery = nil
        self.connectedRobotPeripheral = nil
        if !isScanning {
            self.robotDiscoveries = []
        }
    }

    // MARK: Internal

    // MARK: - Private variables

    let bleManager: BLEManager
    var cancellables: Set<AnyCancellable> = []
    var scanForRobotsTask: AnyCancellable?

    // MARK: - Published variables

    @Published var selectedRobotDiscovery: RobotDiscoveryModel?
    // TODO(@ladislas): are they both needed?
    @Published var connectedRobotDiscovery: RobotDiscoveryModel?
    @Published var connectedRobotPeripheral: RobotPeripheral?
    @Published var robotDiscoveries: [RobotDiscoveryModel] = []
    @Published var isScanning: Bool = false

    // MARK: Private

    private func subscribeToScanningStatus() {
        bleManager.isScanning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                self.isScanning = status
            }
            .store(in: &cancellables)
    }
}
