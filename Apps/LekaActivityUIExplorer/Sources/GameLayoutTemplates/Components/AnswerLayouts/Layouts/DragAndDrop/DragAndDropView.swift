// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

struct DragAndDropSceneView: View {

    @EnvironmentObject var gameEngine: GameEngine
    var withTemplate: DragAndDropScene

    var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .edgesIgnoringSafeArea([.bottom, .horizontal])
    }

    private func makeScene(size: CGSize) -> SKScene {
        let dragAndDropScene: DragAndDropScene = withTemplate
        dragAndDropScene.gameEngine = gameEngine
        dragAndDropScene.size = CGSize(width: size.width, height: size.height)

        return dragAndDropScene
    }
}
