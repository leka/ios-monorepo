// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

// MARK: - RobotDiscoveryViewModel

public struct RobotDiscoveryViewModel: Identifiable {
    // MARK: Lifecycle

    init(
        name: String, osVersion: String, battery: Int, isCharging: Bool, isDeepSleeping: Bool, status: Status = .unselected
    ) {
        self.id = UUID()
        self.name = name
        self.status = status
        self.osVersion = osVersion
        self.battery = BatteryViewModel(level: battery)
        self.isCharging = isCharging
        self.isDeepSleeping = isDeepSleeping
    }

    init(discovery: RobotDiscoveryModel, status: Status = .unselected) {
        self.id = discovery.id
        self.name = discovery.name
        self.status = status
        self.osVersion = discovery.osVersion
        self.battery = BatteryViewModel(level: discovery.battery)
        self.isCharging = discovery.isCharging
        self.isDeepSleeping = discovery.isDeepSleeping
    }

    // MARK: Public

    public enum Status: CaseIterable {
        case connected
        case unselected
        case selected
    }

    public let id: UUID
    public let name: String
    public let status: Status
    public let osVersion: String
    public let battery: BatteryViewModel
    public let isCharging: Bool
    public let isDeepSleeping: Bool
}

// MARK: Equatable

extension RobotDiscoveryViewModel: Equatable {
    public static func == (lhs: RobotDiscoveryViewModel, rhs: RobotDiscoveryViewModel) -> Bool {
        lhs.id == rhs.id
            && lhs.battery == rhs.battery
            && lhs.isCharging == rhs.isCharging
    }
}
