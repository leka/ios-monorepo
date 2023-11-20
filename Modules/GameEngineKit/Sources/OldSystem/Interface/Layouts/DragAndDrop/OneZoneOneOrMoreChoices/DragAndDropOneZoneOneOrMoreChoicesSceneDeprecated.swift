// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

final class DragAndDropOneZoneOneOrMoreChoicesSceneDeprecated: DragAndDropBaseSceneDeprecated {
    override func layoutDropZones(dropZones: [DragAndDropZoneModel]) {
        let dropZoneNode = SKSpriteNode()
        let dropZoneSize = CGSize(width: 380, height: 280)
        dropZoneNode.size = dropZoneSize
        dropZoneNode.texture = SKTexture(imageNamed: dropZones[0].value)
        dropZoneNode.position = CGPoint(x: size.width / 2, y: dropZoneSize.height / 2)
        dropZoneNode.name = dropZones[0].value
        addChild(dropZoneNode)

        dropZonesNode.append(dropZoneNode)
    }
}
