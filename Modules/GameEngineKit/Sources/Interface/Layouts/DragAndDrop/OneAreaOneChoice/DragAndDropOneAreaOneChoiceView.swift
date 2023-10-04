// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

public struct DragAndDropOneAreaOneChoiceView: View {
    @ObservedObject private var viewModel: GenericViewModel
    //    @StateObject private var scene: DragAndDropOneAreaOneChoiceScene
    @State private var scene: SKScene = SKScene()
    var contexts: [ContextViewModel]
    @State private var id = UUID()

    public init(gameplay: any GameplayProtocol, contexts: [ContextViewModel]) {
        //        self._scene = StateObject(wrappedValue: DragAndDropOneAreaOneChoiceScene(contexts: contexts))
        self.viewModel = GenericViewModel(gameplay: gameplay)
        self.contexts = contexts
    }

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .id(id)
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                scene = DragAndDropOneAreaOneChoiceScene(contexts: contexts)
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DragAndDropSceneProtocol else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = viewModel

        return finalScene
    }
}
