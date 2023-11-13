// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

extension SKSpriteNode {
    func fullyContainsDeprecated(bounds: CGRect) -> Bool {
        (self.position.x - (self.size.width / 2) >= bounds.minX)
            && (self.position.y - (self.size.height / 2) >= bounds.minY)
            && (self.position.x + (self.size.width / 2) <= bounds.maxX)
            && (self.position.y + (self.size.height / 2) <= bounds.maxY)
    }
    func fullyContainsDeprecated(location: CGPoint, bounds: CGRect) -> Bool {
        (location.x - (self.size.width / 3) >= bounds.minX)
            && (location.y - (self.size.height / 3) >= bounds.minY)
            && (location.x + (self.size.width / 3) <= bounds.maxX)
            && (location.y + (self.size.height / 3) <= bounds.maxY)
    }

    // make sure the bigger side of a node measures a max of 170 pts
    func scaleForMaxDeprecated(sizeOf: CGFloat) {
        let initialSize = self.texture?.size()
        let biggerSide = max(initialSize!.width, initialSize!.height)
        let scaler = sizeOf / biggerSide
        self.setScale(scaler)
    }
}
