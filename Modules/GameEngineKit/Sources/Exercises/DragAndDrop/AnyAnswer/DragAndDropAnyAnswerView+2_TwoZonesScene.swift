// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

extension DragAndDropAnyAnswerView {
    final class TwoZonesScene: DragAndDropAnyAnswerView.BaseScene {
        override func layoutDropZones() {
            guard let unwrappedDropZoneB = dropZoneB else {
                fatalError("No dropZoneB provided")
            }

            // TODO(@hugo): Add type declaration
            let dropZoneNodeA = SKSpriteNode()
            let dropZoneNodeB = SKSpriteNode()

            let dropZoneSize = CGSize(width: 420, height: 315)
            dropZoneNodeA.size = dropZoneSize
            dropZoneNodeB.size = dropZoneSize

            guard let pathA = Bundle.path(forImage: dropZoneA.details.value) else {
                fatalError("No path founded for dropzoneA asset")
            }
            guard let pathB = Bundle.path(forImage: unwrappedDropZoneB.details.value) else {
                fatalError("No path founded for dropzoneB asset")
            }

            dropZoneNodeA.texture = SKTexture(image: UIImage(named: pathA)!)
            dropZoneNodeB.texture = SKTexture(image: UIImage(named: pathB)!)

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
