// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// TODO(@ladislas): move to UtilsKit frameworks
extension String {
    public static func random(length: Int)
        -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}

extension RobotDiscoveryViewModel {
    public static func mock(
        name: String = "LK-\(String.random(length: 12))",
        battery: Int = Int.random(in: 0...100),
        isCharging: Bool = Bool.random(),
        osVersion: String = "1.3.0",
        status: Status = .unselected
    ) -> RobotDiscoveryViewModel {
        .init(
            name: name,
            battery: battery,
            isCharging: isCharging,
            osVersion: osVersion,
            status: status)
    }
}
