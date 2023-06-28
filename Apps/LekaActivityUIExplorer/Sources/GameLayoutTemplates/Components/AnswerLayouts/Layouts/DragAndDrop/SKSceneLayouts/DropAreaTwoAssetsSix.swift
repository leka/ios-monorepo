// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SpriteKit

class DropAreaTwoAssetsSix: DropAreaTwoAssetsTwo {

    let padding: CGFloat = 100

    override func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        spacer = (size.width - (padding * 2)) / 5
        self.defaultPosition = CGPoint(x: padding, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }

    override func makeDropArea() {
        dropArea.size = CGSize(width: 450, height: 350)
        dropArea.texture = SKTexture(imageNamed: "kitchen_assets_3")
        dropArea.position = CGPoint(x: (size.width / 2) - 275, y: 190)
        dropArea.name = "left_side_drop_area"

        rightSideDropArea.size = CGSize(width: 450, height: 350)
        rightSideDropArea.texture = SKTexture(imageNamed: "bathroom_assets_3")
        rightSideDropArea.position = CGPoint(x: (size.width / 2) + 275, y: 190)
        rightSideDropArea.name = "right_side_drop_area"

        dropAreas = [dropArea, rightSideDropArea]

        addChild(dropArea)
        addChild(rightSideDropArea)

        getExpectedItems()
    }
}
