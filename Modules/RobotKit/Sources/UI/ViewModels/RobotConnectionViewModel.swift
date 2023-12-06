// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Foundation

public class RobotConnectionViewModel: ObservableObject {
    @Published var robotDiscoveries: [RobotDiscoveryModel] = []
    @Published var selectedDiscovery: RobotDiscoveryModel?

    @Published var connectedDiscovery: RobotDiscoveryModel? {
        didSet {
            connected = connectedDiscovery != nil
        }
    }

    @Published var connected: Bool = false

    private let robot = Robot.shared
    private let bleManager = BLEManager.shared

    private var cancellables: Set<AnyCancellable> = []
    private var scanCancellable: AnyCancellable?

    public init() {
        self.connected = bleManager.isConnected
    }

    public func select(discovery: RobotDiscoveryModel) {
        if selectedDiscovery == discovery {
            selectedDiscovery = nil
            log.trace("Unselected: \(discovery.id)")
            return
        }

        selectedDiscovery = discovery
        log.trace("Selected: \(discovery.id)")
    }

    public func scanForRobots() {
        log.info("🔵 BLE - Start scanning for robots")
        scanCancellable = bleManager.scanForRobots()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // nothing to do
            } receiveValue: { [weak self] discoveries in
                guard let self = self else { return }
                self.robotDiscoveries = discoveries
                log.trace("🔵 BLE - Discoveries found: \(discoveries)")
            }
    }

    public func stopScanning() {
        log.info("🔵 BLE - Stop scanning for robots")
        scanCancellable = nil
    }

    public func connectToRobot() {
        guard let discovery = selectedDiscovery else {
            return
        }
        bleManager.connect(discovery)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // nothing to do
            } receiveValue: { [weak self] peripheral in
                guard let self = self else { return }
                robot.connectedPeripheral = peripheral
                self.connectedDiscovery = discovery
                self.selectedDiscovery = nil
                log.info("🔵 BLE - Connected to \(robot.name.value)")
            }
            .store(in: &cancellables)
    }

    public func disconnectFromRobot() {
        log.info("🔵 BLE - Disconnecting from \(robot.name.value)")
        bleManager.disconnect()
        connectedDiscovery = nil
    }
}
