// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

extension SKAction {
    func moveAnimationDeprecated(_ timingMode: SKActionTimingMode) -> SKAction {
        self.timingMode = timingMode
        return self
    }
}
