// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

public struct RobotDiscoveryViewModel: Identifiable {

    public enum Status: CaseIterable {
        case connected
        case unselected
        case selected
    }

    public let id: UUID
    public let name: String
    public let status: Status
    public let isCharging: Bool
    public let osVersion: String
    public let battery: BatteryViewModel

    init(
        name: String, battery: Int, isCharging: Bool, osVersion: String, status: Status = .unselected
    ) {
        self.id = UUID()
        self.name = name
        self.status = status
        self.isCharging = isCharging
        self.osVersion = "LekaOS \(osVersion)"
        self.battery = BatteryViewModel(level: battery)
    }

    init(discovery: RobotDiscoveryModel, status: Status = .unselected) {
        self.id = discovery.id
        self.name = discovery.name
        self.status = status
        self.isCharging = discovery.isCharging
        self.osVersion = "LekaOS \(discovery.osVersion)"
        self.battery = BatteryViewModel(level: discovery.battery)
    }

}

extension RobotDiscoveryViewModel: Equatable {

    public static func == (lhs: RobotDiscoveryViewModel, rhs: RobotDiscoveryViewModel) -> Bool {
        lhs.id == rhs.id
            && lhs.isCharging == rhs.isCharging
            && lhs.battery == rhs.battery
    }

}
