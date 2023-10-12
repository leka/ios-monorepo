// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

final class DragAndDropTwoAreasOneOrMoreChoicesScene: DragAndDropBaseScene {
    override func layoutDropAreas(dropZones: [DragAndDropZoneModel]) {
        let dropAreaSpacer = size.width / 4
        var dropAreaPosition = dropAreaSpacer
        for dropArea in dropZones {
            let dropAreaNode = SKSpriteNode()
            dropAreaNode.size = dropArea.size
            dropAreaNode.texture = SKTexture(imageNamed: dropArea.item)
            dropAreaNode.position = CGPoint(x: dropAreaPosition, y: dropArea.size.height / 2)
            dropAreaNode.name = dropArea.item
            addChild(dropAreaNode)

            dropAreasNode.append(dropAreaNode)

            dropAreaPosition += 2 * dropAreaSpacer
        }
    }
}
