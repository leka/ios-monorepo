// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import SwiftUI

@MainActor
public class RobotConnectionViewModel: ObservableObject {

    // MARK: - Published/public variables

    // TODO(@ladislas): replace by RobotDiscovery model
    @Published public var robotDiscoveries: [RobotDiscoveryViewModel]?

    @Published public var selectedRobotDiscovery: RobotDiscoveryViewModel?
    @Published public var connectedRobotDiscovery: RobotDiscoveryViewModel?

    @Published public var scanForRobotsTask: AnyCancellable?

    public var connectionButtonDisabled: Bool {
        if connected {
            return false
        }
        return selectedRobotDiscovery == nil
    }

    public var connected: Bool {
        connectedRobotDiscovery != nil ? true : false
    }

    public var disconnected: Bool {
        connectedRobotDiscovery == nil ? true : false
    }

    // MARK: - Private variables

    private let bleManager = BLEManager.live()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public functions

    init() {
        subscribeToSelectedRobot()
        subscribeToConnectedRobot()
    }

    public func scanForRobots() {
        scanForRobotsTask = bleManager.scanForRobots()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    // nothing to do
                },
                receiveValue: { robotDiscoveryList in
                    self.robotDiscoveries = robotDiscoveryList.map { robotDiscovery in
                        RobotDiscoveryViewModel(robotDiscovery: robotDiscovery)
                    }
                })
    }

    public func connectToSelectedRobot() {
        guard let selectedRobotDiscovery = selectedRobotDiscovery else {
            return
        }

        scanForRobotsTask?.cancel()

        self.connectedRobotDiscovery = selectedRobotDiscovery
        self.selectedRobotDiscovery = nil
    }

    public func disconnectFromRobot() {
        self.connectedRobotDiscovery = nil
    }

    // MARK: - Private functions

    private func subscribeToSelectedRobot() {
        $selectedRobotDiscovery
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedRobotDiscovery in
                guard let self = self else { return }

                self.robotDiscoveries = self.robotDiscoveries.map { robotDiscoveries in
                    robotDiscoveries.compactMap { discovery in
                        switch discovery.status {
                            case .connected:
                                break
                            case .selected:
                                discovery.status = .unselected
                            case .unselected:
                                if discovery == selectedRobotDiscovery {
                                    discovery.status = .selected
                                }
                        }

                        return discovery
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func subscribeToConnectedRobot() {
        $connectedRobotDiscovery
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connectedRobotDiscovery in
                guard let self = self else { return }

                self.robotDiscoveries = self.robotDiscoveries.map { robotDiscoveries in
                    robotDiscoveries.compactMap { discovery in
                        switch discovery.status {
                            case .connected:
                                discovery.status = .unselected
                            case .selected:
                                if connectedRobotDiscovery == discovery {
                                    discovery.status = .connected
                                }
                            case .unselected:
                                break
                        }

                        return discovery
                    }
                }
            }
            .store(in: &cancellables)
    }

}
