// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

extension DragAndDropIntoZonesView {
    final class TwoZonesScene: DragAndDropIntoZonesView.BaseScene {
        override func layoutDropZones() {
            guard let unwrappedDropZoneB = dropZoneB else {
                fatalError("No dropZoneB provided")
            }

            // TODO(@hugo): Add type declaration
            let dropZoneNodeA = SKSpriteNode()
            let dropZoneNodeB = SKSpriteNode()

            let dropZoneSize = CGSize(width: 410, height: 320)
            dropZoneNodeA.size = dropZoneSize
            dropZoneNodeB.size = dropZoneSize

            dropZoneNodeA.texture = SKTexture(imageNamed: dropZoneA.details.value)
            dropZoneNodeB.texture = SKTexture(imageNamed: unwrappedDropZoneB.details.value)

            let dropZonePosition = size.width / 4
            dropZoneNodeA.position = CGPoint(x: dropZonePosition, y: dropZoneSize.height * 5 / 7)
            dropZoneNodeB.position = CGPoint(x: dropZonePosition * 3, y: dropZoneSize.height * 5 / 7)

            dropZoneNodeA.name = dropZoneA.details.value
            dropZoneNodeB.name = unwrappedDropZoneB.details.value
            addChild(dropZoneNodeA)
            addChild(dropZoneNodeB)

            dropZoneA.node = dropZoneNodeA
            dropZoneB?.node = dropZoneNodeB
        }
    }
}