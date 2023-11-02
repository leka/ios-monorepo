// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit
import SwiftUI

final class DragAndDropTwoZonesScene: DragAndDropBaseScene {
    override func layoutDropZones(dropZones: DropZoneDetails...) {
        // TODO(@hugo): Add type declaration
        let dropZoneSpacer = size.width / 4
        var dropZonePosition = dropZoneSpacer
        for dropZone in dropZones {
            let dropZoneNode = SKSpriteNode()
            // TODO(@hugo): Adapt size to final images given by the Design team
            let dropZoneSize = CGSize(width: 280, height: 280)
            dropZoneNode.size = dropZoneSize
            dropZoneNode.texture = SKTexture(imageNamed: dropZone.value)
            dropZoneNode.position = CGPoint(x: dropZonePosition, y: dropZoneSize.height / 2)
            dropZoneNode.name = dropZone.value
            addChild(dropZoneNode)

            dropZoneNodes.append(dropZoneNode)

            dropZonePosition += 2 * dropZoneSpacer
        }
    }
}
