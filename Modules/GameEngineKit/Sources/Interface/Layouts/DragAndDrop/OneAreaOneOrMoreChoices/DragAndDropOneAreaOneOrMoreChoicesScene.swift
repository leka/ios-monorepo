// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

final class DragAndDropOneAreaOneOrMoreChoicesScene: DragAndDropBaseScene {

    public init(viewModel: GenericViewModel, dropArea: DropAreaModel) {
        super.init(viewModel: viewModel, dropAreas: dropArea)

        subscribeToChoicesUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutDropAreas(dropAreas: [DropAreaModel]) {
        let dropAreaNode = SKSpriteNode()
        dropAreaNode.size = dropAreas[0].size
        dropAreaNode.texture = SKTexture(imageNamed: dropAreas[0].file)
        dropAreaNode.position = CGPoint(x: size.width / 2, y: dropAreas[0].size.height / 2)
        dropAreaNode.name = dropAreas[0].file
        addChild(dropAreaNode)

        dropAreasNode.append(dropAreaNode)
    }
}
