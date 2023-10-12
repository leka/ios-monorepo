// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

final class DragAndDropOneZoneOneOrMoreChoicesScene: DragAndDropBaseScene {
    override func layoutDropZones(dropZones: [DragAndDropZoneModel]) {
        let dropZoneNode = SKSpriteNode()
        dropZoneNode.size = dropZones[0].size
        dropZoneNode.texture = SKTexture(imageNamed: dropZones[0].value)
        dropZoneNode.position = CGPoint(x: size.width / 2, y: dropZones[0].size.height / 2)
        dropZoneNode.name = dropZones[0].value
        addChild(dropZoneNode)

        dropZonesNode.append(dropZoneNode)
    }
}
