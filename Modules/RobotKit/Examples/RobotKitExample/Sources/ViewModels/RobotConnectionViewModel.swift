// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Foundation
import RobotKit

class RobotConnectionViewModel: ObservableObject {

    @Published var robotDiscoveries: [RobotDiscoveryModel] = []
    @Published var selectedDiscovery: RobotDiscoveryModel?

    @Published var connectedDiscovery: RobotDiscoveryModel? {
        didSet {
            connected = connectedDiscovery != nil ? true : false
        }
    }

    @Published var connected: Bool = false

    private let bleManager = BLEManager.shared

    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.connected = bleManager.isConnected
    }

    public func select(discovery: RobotDiscoveryModel) {
        if selectedDiscovery == discovery {
            selectedDiscovery = nil
            print("unselect \(discovery.id)")
            return
        }

        selectedDiscovery = discovery
        print("select \(discovery.id)")
    }

    public func scanForRobots() {
        bleManager.scanForRobots()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // nothing to do
            } receiveValue: { [weak self] discoveries in
                guard let self = self else { return }
                self.robotDiscoveries = discoveries
            }
            .store(in: &cancellables)
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
                let robot = Robot.shared
                robot.connectedPeripheral = peripheral
                self.connectedDiscovery = discovery
                self.selectedDiscovery = nil
            }
            .store(in: &cancellables)
    }

    public func disconnectFromRobot() {
        bleManager.disconnect()
        connectedDiscovery = nil
    }

}
