// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import CombineCoreBluetooth
import CoreBluetooth
import CryptoKit

extension RobotDiscovery {

    public static func mock() -> RobotDiscovery {
        return RobotDiscovery.init(
            name: "Leka Mock", osVersion: "1.2.3", battery: Int.random(in: 1..<100), isCharging: Bool.random())
    }

}
