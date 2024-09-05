// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UtilsKit

public extension RobotDiscoveryViewModel {
    static func mock(
        name: String = "LK-\(String.random(length: 12))",
        osVersion: String = "1.3",
        battery: Int = Int.random(in: 0...100),
        isCharging: Bool = Bool.random(),
        isDeepSleeping: Bool = Bool.random(),
        status: Status = .unselected
    ) -> RobotDiscoveryViewModel {
        .init(
            name: name,
            osVersion: osVersion,
            battery: battery,
            isCharging: isCharging,
            isDeepSleeping: isDeepSleeping,
            status: status
        )
    }
}
