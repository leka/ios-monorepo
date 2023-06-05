// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

struct DragAndDropSceneView: View {

    @EnvironmentObject var gameEngine: GameEngine

    var body: some View {
        GeometryReader { proxy in
            SpriteView(scene: makeScene(size: proxy.size), options: [.allowsTransparency])
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .edgesIgnoringSafeArea([.bottom, .horizontal])
    }

    private func makeScene(size: CGSize) -> SKScene {
        let dragAndDropScene: DragAndDropScene = DragAndDropScene()

        // configure dropArea here
        dragAndDropScene.dropArea.size = CGSize(width: 380, height: 280)
        dragAndDropScene.dropArea.texture = SKTexture(imageNamed: "basket")
        dragAndDropScene.dropArea.position = CGPoint(x: size.width / 2, y: 165)
        dragAndDropScene.gameEngine = gameEngine

        // layout within available space
        dragAndDropScene.size = CGSize(width: size.width, height: size.height)
        let itemCount = CGFloat(gameEngine.allAnswers.count)
        dragAndDropScene.spacer = size.width / (itemCount + 1)

        return dragAndDropScene
    }
}
