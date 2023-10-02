// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

struct DragAndDropHostView: View {

    @ObservedObject var viewModel: GenericViewModel
    @Binding var scene: SKScene

    var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func makeScene(size: CGSize) -> SKScene {
        //    func makeScene(size: CGSize) -> SKScene {
        let dragAndDropScene: SKScene = scene
        guard let properScene = dragAndDropScene as? DragAndDropSceneProtocol else {
            return SKScene()
        }
        properScene.size = CGSize(width: size.width, height: size.height)
        properScene.viewModel = viewModel

        return properScene
    }
}
