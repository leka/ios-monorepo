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
        let newY = max(dropZoneFrame.minY + size.height / 2,
                       min(position.y, dropZoneFrame.maxY - size.height / 2))

        self.moveSmoothly(to: CGPoint(x: newX, y: newY))
    }

    func snapToCenter(dropZone: SKSpriteNode) {
        let dropZoneFrame = dropZone.frame

        let newX = max(dropZoneFrame.minX + size.width / 2,
                       min(position.x, dropZoneFrame.maxX - size.width / 2))
        let newY = max(dropZoneFrame.minY + size.height / 2,
                       min(position.y, dropZoneFrame.maxY - size.height / 2))

        self.moveSmoothly(to: CGPoint(x: newX, y: newY))
    }

    func moveSmoothly(to targetPosition: CGPoint) {
        let moveToCenter = SKAction.move(to: targetPosition, duration: 0.2)
        moveToCenter.timingMode = .easeInEaseOut

        run(
            moveToCenter,
            completion: {
                self.position = targetPosition
                self.zRotation = 0
                self.zPosition = 10
                self.removeAllActions()
            }
        )
    }
}
