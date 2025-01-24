// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI
import UtilsKit

extension DnDAnswerNode {
    func triggerDefaultIdleBehavior() {
        self.moveNodeBackToInitialPosition()
    }

    func triggerDefaultDraggedBehavior() {
        self.onDragAnimation()
    }

    func triggerDefaultWrongBehavior() {
        self.moveNodeBackToInitialPosition()
        self.colorBlendFactor = 0.5
        self.isDraggable = false
    }

    func moveNodeBackToInitialPosition() {
        self.run(
            SKAction.move(to: self.initialPosition ?? .zero, duration: 0.25),
            completion: {
                self.position = self.initialPosition ?? .zero
                self.onDropAction()
            }
        )
    }

    func onDragAnimation() {
        let wiggleAnimation = SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
            SKAction.rotate(byAngle: 0.0, duration: 0.1),
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
        ])
        self.zPosition += 100
        self.run(SKAction.repeatForever(wiggleAnimation))
        self.scale(to: CGSize(width: self.size.width * 1.25, height: self.size.height * 1.25))
    }

    func onDropAction() {
        self.zRotation = 0
        self.zPosition = 10
        self.removeAllActions()
        self.scale(to: self.initialSize)
    }

    func repositionInside(dropZone: SKSpriteNode) {
        self.scale(to: self.initialSize)
        let dropZoneFrame = dropZone.frame

        let newX = max(dropZoneFrame.minX + size.width / 2,
                       min(position.x, dropZoneFrame.maxX - size.width / 2))
        let newY = max(dropZoneFrame.minY + size.height / 2,
                       min(position.y, dropZoneFrame.maxY - size.height / 2))

        self.moveSmoothly(to: CGPoint(x: newX, y: newY))
    }

    func snapToCenter(dropZone: SKSpriteNode) {
        self.scale(to: self.initialSize)
        let dropZoneFrame = dropZone.frame

        let newX = max(dropZoneFrame.minX + size.width / 2,
                       min(position.x, dropZoneFrame.maxX - size.width / 2))
        let newY = max(dropZoneFrame.minY + size.height / 2,
                       min(position.y, dropZoneFrame.maxY - size.height / 2))

        self.moveSmoothly(to: CGPoint(x: newX, y: newY))
    }

    func moveSmoothly(to targetPosition: CGPoint) {
        let moveToCenter = SKAction.move(to: targetPosition, duration: 0.1)
        moveToCenter.timingMode = .easeInEaseOut

        run(
            moveToCenter,
            completion: {
                self.position = targetPosition
                self.onDropAction()
            }
        )
    }
}
