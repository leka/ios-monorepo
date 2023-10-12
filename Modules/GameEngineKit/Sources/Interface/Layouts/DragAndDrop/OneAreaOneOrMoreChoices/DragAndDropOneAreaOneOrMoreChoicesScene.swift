// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

final class DragAndDropOneAreaOneOrMoreChoicesScene: DragAndDropBaseScene {
    override func layoutDropAreas(dropZones: [DragAndDropZoneModel]) {
        let dropAreaNode = SKSpriteNode()
        dropAreaNode.size = dropZones[0].size
        dropAreaNode.texture = SKTexture(imageNamed: dropZones[0].value)
        dropAreaNode.position = CGPoint(x: size.width / 2, y: dropZones[0].size.height / 2)
        dropAreaNode.name = dropZones[0].value
        addChild(dropAreaNode)

        dropAreasNode.append(dropAreaNode)
    }
}
