// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import CoreBluetooth
import Foundation
import Observation

@Observable
public class RobotConnectionViewModel {
    // MARK: Lifecycle

    public init() {
        self.connected = self.bleManager.isConnected
        self.subscribeToManagerState()
        self.subscribeToDidDisconnect()
    }

    // MARK: Public

    public private(set) var connectedDiscovery: RobotDiscoveryModel? {
        didSet {
            self.connected = self.connectedDiscovery != nil
        }
    }

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
        // ? On first appear, scan is not working because it is called twice.
        // ? Setting it to nil first fixes the issues.
        // TODO: (@leka/dev-ios) review usage of nil here to fix scan
        self.scanCancellable = nil
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
        self.robotDiscoveries = []
    }

    public func connectToRobot() {
        guard let discovery = selectedDiscovery else {
            return
        }

        if discovery.isDeepSleeping, !self.connectingToRestartingRobot {
            self.connectToRobotInDeepSleep()
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
                self.connectingToRestartingRobot = false
                log.info("🔵 BLE - Connected to \(self.robot.name.value)")
            }
            .store(in: &self.cancellables)
    }

    public func connectToRobotInDeepSleep() {
        guard let discovery = selectedDiscovery else {
            return
        }

        self.connectingToRestartingRobot = true

        self.bleManager.connect(discovery)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // nothing to do
            } receiveValue: { _ in
                // nothing to do
            }
            .store(in: &self.cancellables)

        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: self.connectToRobot)
    }

    public func disconnectFromRobot() {
        log.info("🔵 BLE - Disconnecting from \(self.robot.name.value)")
        self.bleManager.disconnect()
        self.connectedDiscovery = nil
    }

    public func tryToConnectToRobotConnectedInAnotherApp() {
        let connectedRobots = BLEManager.shared.retrieveConnectedRobots()
        if connectedRobots.isEmpty || connectedRobots[0].peripheral.state == .connected {
            return
        }

        let connectedRobotDiscoveryModel = RobotDiscoveryModel(robotPeripheral: connectedRobots[0], advertisingData: nil, rssi: nil)

        self.select(discovery: connectedRobotDiscoveryModel)
        self.connectToRobot()
    }

    public func setRobotDiscoveries(_ discoveries: [RobotDiscoveryModel]) {
        self.robotDiscoveries = discoveries
    }

    // MARK: Internal

    private(set) var robotDiscoveries: [RobotDiscoveryModel] = []
    private(set) var selectedDiscovery: RobotDiscoveryModel?

    private(set) var connected: Bool = false
    private(set) var connectingToRestartingRobot: Bool = false
    private(set) var managerState: CBManagerState = .unknown

    // MARK: Private

    @ObservationIgnored private let robot = Robot.shared
    @ObservationIgnored private let bleManager = BLEManager.shared

    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    @ObservationIgnored private var scanCancellable: AnyCancellable?

    private func subscribeToManagerState() {
        self.bleManager.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                self.managerState = state
                if state == .poweredOn {
                    log.debug("poweredOn - start scanning")
                    self.scanForRobots()
                }
                if state == .poweredOff {
                    log.debug("poweredOff - stop scanning")
                    self.stopScanning()
                    self.selectedDiscovery = nil
                }
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
