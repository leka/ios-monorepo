// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

extension SKAction {
    func moveAnimation(_ timingMode: SKActionTimingMode) -> SKAction {
        self.timingMode = timingMode
        return self
    }
}
