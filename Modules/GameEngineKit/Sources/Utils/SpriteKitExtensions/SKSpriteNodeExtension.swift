// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

extension SKSpriteNode {
    func fullyContains(bounds: CGRect) -> Bool {
        (position.x - (size.width / 2) >= bounds.minX)
            && (position.y - (size.height / 2) >= bounds.minY)
            && (position.x + (size.width / 2) <= bounds.maxX)
            && (position.y + (size.height / 2) <= bounds.maxY)
    }

    func fullyContains(location: CGPoint, bounds: CGRect) -> Bool {
        (location.x - (size.width / 3) >= bounds.minX)
            && (location.y - (size.height / 3) >= bounds.minY)
            && (location.x + (size.width / 3) <= bounds.maxX)
            && (location.y + (size.height / 3) <= bounds.maxY)
    }

    // make sure the bigger side of a node measures a max of 170 pts
    func scaleForMax(sizeOf: CGFloat) {
        let initialSize = texture?.size()
        let biggerSide = max(initialSize!.width, initialSize!.height)
        let scaler = sizeOf / biggerSide
        setScale(scaler)
    }
}
