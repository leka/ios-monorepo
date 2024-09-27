// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public extension RobotDiscoveryModel {
    static func mock() -> RobotDiscoveryModel {
        RobotDiscoveryModel(
            name: "Leka Mock", osVersion: "1.2", isCharging: Bool.random(), battery: Int.random(in: 1..<100), isDeepSleeping: false
        )
    }
}
