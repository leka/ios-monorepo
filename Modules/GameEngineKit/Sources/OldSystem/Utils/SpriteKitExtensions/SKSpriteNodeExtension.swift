// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

extension SKSpriteNode {
    func repositionInside(dropZone: SKSpriteNode) {
        let dropZoneFrame = dropZone.frame

        let newX = max(dropZoneFrame.minX + size.width / 2,
                       min(position.x, dropZoneFrame.maxX - size.width / 2))
        let newY = max(dropZoneFrame.minY + size.height / 3,
                       min(position.y, dropZoneFrame.maxY - size.height / 3))

        position = CGPoint(x: newX, y: newY)
    }

    func snapToCenter(dropZone: SKSpriteNode) {
        let dropZoneFrame = dropZone.frame

        let newX = max(dropZoneFrame.minX + size.width / 2,
                       min(position.x, dropZoneFrame.maxX - size.width / 2))
        let newY = max(dropZoneFrame.minY + size.height / 2,
                       min(position.y, dropZoneFrame.maxY - size.height / 2))

        position = CGPoint(x: newX, y: newY)
    }

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
