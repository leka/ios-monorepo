// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

public struct RobotDiscoveryViewModel: Identifiable {

    public struct Battery: Equatable {
        let value: Int
        let name: String
        let color: Color
    }

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
    public let battery: Battery

    init(
        name: String, battery: Int, isCharging: Bool, osVersion: String, status: Status = .unselected
    ) {
        self.id = UUID()
        self.name = name
        self.status = status
        self.isCharging = isCharging
        self.osVersion = "LekaOS \(osVersion)"
        self.battery = computeBatteryImage(for: battery)
    }

    init(discovery: RobotDiscoveryModel, status: Status = .unselected) {
        self.id = discovery.id
        self.name = discovery.name
        self.status = status
        self.isCharging = discovery.isCharging
        self.osVersion = "LekaOS \(discovery.osVersion)"
        self.battery = computeBatteryImage(for: discovery.battery)
    }

}

extension RobotDiscoveryViewModel: Equatable {

    public static func == (lhs: RobotDiscoveryViewModel, rhs: RobotDiscoveryViewModel) -> Bool {
        lhs.id == rhs.id
            && lhs.isCharging == rhs.isCharging
            && lhs.battery == rhs.battery
    }

}

private func computeBatteryImage(for value: Int) -> RobotDiscoveryViewModel.Battery {
    switch value {
        case 0..<10:
            RobotDiscoveryViewModel.Battery(value: value, name: "battery.0", color: .red)
        case 10..<25:
            RobotDiscoveryViewModel.Battery(value: value, name: "battery.25", color: .red)
        case 25..<45:
            RobotDiscoveryViewModel.Battery(value: value, name: "battery.25", color: .orange)
        case 45..<70:
            RobotDiscoveryViewModel.Battery(value: value, name: "battery.50", color: .yellow)
        case 70..<95:
            RobotDiscoveryViewModel.Battery(value: value, name: "battery.75", color: .green)
        default:
            RobotDiscoveryViewModel.Battery(value: value, name: "battery.100", color: .green)
    }
}
