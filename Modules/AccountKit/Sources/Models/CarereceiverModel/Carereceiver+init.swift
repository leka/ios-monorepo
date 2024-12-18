// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

public extension Carereceiver {
    init(
        id: String = "",
        rootOwnerUid: String = "",
        username: String = "",
        avatar: String = "",
        reinforcer: Robot.Reinforcer = .rainbow
    ) {
        self.id = id
        self.rootOwnerUid = rootOwnerUid
        self.username = username
        self.avatar = avatar
        self.reinforcer = reinforcer
    }
}
