// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import CoreBluetooth
import Foundation

public class RobotConnectionViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.connected = self.bleManager.isConnected
        self.subscribeToManagerState()
        self.subscribeToDidDisconnect()
    }

    // MARK: Public

    public func select(discovery: RobotDiscoveryModel) {
        if self.selectedDiscovery == discovery {
            self.selectedDiscovery = nil
            log.trace("Unselected: \(discovery.id)")
            return
        }

        self.selectedDiscovery = discovery
        log.trace("Selected: \(discovery.id)")
    }

    public func scanForRobots() {
        log.info("🔵 BLE - Start scanning for robots")
        self.scanCancellable = self.bleManager.scanForRobots()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // nothing to do
            } receiveValue: { [weak self] discoveries in
                guard let self else { return }
                self.robotDiscoveries = discoveries
                log.trace("🔵 BLE - Discoveries found: \(discoveries)")
            }
    }

    public func stopScanning() {
        log.info("🔵 BLE - Stop scanning for robots")
        self.scanCancellable = nil
    }

    public func connectToRobot() {
        guard let discovery = selectedDiscovery else {
            return
        }
        self.bleManager.connect(discovery)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // nothing to do
            } receiveValue: { [weak self] peripheral in
                guard let self else { return }
                self.robot.connectedPeripheral = peripheral
                self.connectedDiscovery = discovery
                self.selectedDiscovery = nil
                log.info("🔵 BLE - Connected to \(self.robot.name.value)")
            }
            .store(in: &self.cancellables)
    }

    public func disconnectFromRobot() {
        log.info("🔵 BLE - Disconnecting from \(self.robot.name.value)")
        self.bleManager.disconnect()
        self.connectedDiscovery = nil
    }

    // MARK: Internal

    @Published var robotDiscoveries: [RobotDiscoveryModel] = []
    @Published var selectedDiscovery: RobotDiscoveryModel?

    @Published var connected: Bool = false
    @Published var managerState: CBManagerState = .unknown

    @Published var connectedDiscovery: RobotDiscoveryModel? {
        didSet {
            self.connected = self.connectedDiscovery != nil
        }
    }

    // MARK: Private

    private let robot = Robot.shared
    private let bleManager = BLEManager.shared

    private var cancellables: Set<AnyCancellable> = []
    private var scanCancellable: AnyCancellable?

    private func subscribeToManagerState() {
        self.bleManager.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                self.managerState = state
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToDidDisconnect() {
        self.bleManager.didDisconnect
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.connectedDiscovery = nil
                self.robot.connectedPeripheral = nil
                self.connected = false
            }
            .store(in: &self.cancellables)
    }
}
