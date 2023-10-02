// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Foundation

public class RobotDiscoveryViewModel: ObservableObject, Equatable, Identifiable {
    @Published var name: String
    @Published var battery: Int
    @Published var isCharging: Bool
    @Published var osVersion: String
    @Published var status: RobotGridViewStatus

    public var robotDiscovery: RobotDiscovery?

    init(name: String, battery: Int, isCharging: Bool, osVersion: String, status: RobotGridViewStatus = .unselected) {
        self.name = name
        self.battery = battery
        self.isCharging = isCharging
        self.osVersion = osVersion
        self.status = status
    }

    init(robotDiscovery: RobotDiscovery, status: RobotGridViewStatus = .unselected) {
        self.name = robotDiscovery.name
        self.battery = robotDiscovery.battery
        self.isCharging = robotDiscovery.isCharging
        self.osVersion = robotDiscovery.osVersion
        self.status = status
        self.robotDiscovery = robotDiscovery
    }

    public static func == (lhs: RobotDiscoveryViewModel, rhs: RobotDiscoveryViewModel) -> Bool {
        lhs.robotDiscovery?.id == rhs.robotDiscovery?.id && lhs.name == rhs.name
    }

}
