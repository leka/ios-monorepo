// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UtilsKit

public extension RobotDiscoveryViewModel {
    static func mock(
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
            status: status
        )
    }
}
