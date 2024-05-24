// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

extension DragAndDropIntoZonesView {
    final class OneZoneScene: DragAndDropIntoZonesView.BaseScene {
        override func layoutDropZones() {
            // TODO(@hugo): Add type declaration
            let dropZoneNode = SKSpriteNode()
            let dropZoneSize = CGSize(width: 420, height: 315)

            dropZoneNode.size = dropZoneSize
            guard let path = Bundle.path(forImage: dropZoneA.details.value) else {
                return
            }
            dropZoneNode.texture = SKTexture(image: UIImage(named: path)!)

            dropZoneNode.position = CGPoint(x: size.width / 2, y: dropZoneSize.height / 2)
            dropZoneNode.name = dropZoneA.details.value

            addChild(dropZoneNode)

            dropZoneA.node = dropZoneNode
        }
    }
}
