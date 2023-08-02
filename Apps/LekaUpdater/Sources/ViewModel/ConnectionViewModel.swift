// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

@MainActor
class ConnectionViewModel: ObservableObject {
    //    public var continueButtonDisabled: Bool {
    //        !robotConnectionViewModel.connected // Does not work, value updated only on connection
    //    }
    @Published public var continueButtonDisabled = false

    @Published public var robotConnectionViewModel = RobotConnectionViewModel()

    private var cancellables: Set<AnyCancellable> = []

    init() {
        subscribeConnectedRobotDiscovery()
    }

    private func subscribeConnectedRobotDiscovery() {
        robotConnectionViewModel.$connectedRobotDiscovery
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: self.onConnectedRobotDiscoveryChanged)
            .store(in: &cancellables)
    }

    private func onConnectedRobotDiscoveryChanged(robot: RobotDiscoveryViewModel?) {
        if let robotDiscovery = robot?.robotDiscovery {
            globalRobotManager.copyFrom(robotDiscovery: robotDiscovery)
            continueButtonDisabled = false
        } else {
            continueButtonDisabled = true
        }
    }
}
