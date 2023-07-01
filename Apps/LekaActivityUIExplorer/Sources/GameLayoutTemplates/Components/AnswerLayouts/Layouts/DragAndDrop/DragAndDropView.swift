// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

struct DragAndDropSceneView: View {

    @EnvironmentObject var gameEngine: GameEngine
    var withTemplate: SKScene

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
        let dragAndDropScene: SKScene = withTemplate
        guard let properScene = dragAndDropScene as? DragAndDropSceneProtocol else {
            return SKScene()
        }
        properScene.gameEngine = gameEngine
        properScene.size = CGSize(width: size.width, height: size.height)

        return properScene
    }
}
