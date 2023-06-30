// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

class DummyRobotModel: ObservableObject {
    @Published var name: String
    @Published var serialNumber: String

    @Published var battery: Int
    @Published var isCharging: Bool
    @Published var osVersion: String

    func startUpdate() {
        // Start update process here
        print("Start Update")
    }

    init(
        name: String = "Leka", serialNumber: String = "LK-2206..", battery: Int = 75, isCharging: Bool = false,
        osVersion: String = "1.3.0"
    ) {
        self.name = name
        self.serialNumber = serialNumber

        self.battery = battery
        self.isCharging = isCharging
        self.osVersion = osVersion
    }

    convenience init(robotDiscoveryViewModel: RobotDiscoveryViewModel) {
        self.init(
            name: robotDiscoveryViewModel.name, battery: robotDiscoveryViewModel.battery,
            isCharging: robotDiscoveryViewModel.isCharging, osVersion: robotDiscoveryViewModel.osVersion)
    }
}
