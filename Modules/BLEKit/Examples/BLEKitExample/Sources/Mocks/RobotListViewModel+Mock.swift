// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import SwiftUI

extension RobotListViewModel {
    // TODO(@ladislas): create protocol and mock RobotDiscoveryModel
    public static func mock() -> RobotListViewModel {
        RobotListViewModel(availableRobots: [
            // RobotDiscovery.mock(),
            // RobotDiscovery.mock(),
            // RobotDiscovery.mock(),
            // RobotDiscovery.mock(),
            // RobotDiscovery.mock(),
        ])
    }
}
