// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public extension RobotDiscoveryModel {
    static func mock() -> RobotDiscoveryModel {
        RobotDiscoveryModel(
            name: "Leka Mock", isCharging: Bool.random(), battery: Int.random(in: 1..<100), osVersion: "1.2.3"
        )
    }
}
