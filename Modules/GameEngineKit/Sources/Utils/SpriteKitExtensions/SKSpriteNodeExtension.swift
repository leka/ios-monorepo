// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

extension SKSpriteNode {
    func fullyContains(bounds: CGRect) -> Bool {
        (position.x >= bounds.minX)
            && (position.y >= bounds.minY)
            && (position.x <= bounds.maxX)
            && (position.y <= bounds.maxY)
    }

    func fullyContains(location: CGPoint, bounds: CGRect) -> Bool {
        (location.x >= bounds.minX)
            && (location.y >= bounds.minY)
            && (location.x <= bounds.maxX)
            && (location.y <= bounds.maxY)
    }

    // make sure the bigger side of a node measures a max of 170 pts
    func scaleForMax(sizeOf: CGFloat) {
        let initialSize = texture?.size()
        let biggerSide = max(initialSize!.width, initialSize!.height)
        let scaler = sizeOf / biggerSide
        setScale(scaler)
    }
}
