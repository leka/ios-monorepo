// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

final class DragAndDropTwoZonesOneOrMoreChoicesSceneDeprecated: DragAndDropBaseSceneDeprecated {
    override func layoutDropZones(dropZones: [DragAndDropZoneModel]) {
        let dropAreaSpacer = size.width / 4
        var dropAreaPosition = dropAreaSpacer
        for dropArea in dropZones {
            let dropAreaNode = SKSpriteNode()
            let dropZoneSize = CGSize(width: 380, height: 280)
            dropAreaNode.size = dropZoneSize
            dropAreaNode.texture = SKTexture(imageNamed: dropArea.value)
            dropAreaNode.position = CGPoint(x: dropAreaPosition, y: dropZoneSize.height / 2)
            dropAreaNode.name = dropArea.value
            addChild(dropAreaNode)

            dropZonesNode.append(dropAreaNode)

            dropAreaPosition += 2 * dropAreaSpacer
        }
    }
}
