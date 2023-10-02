// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

public struct DragAndDropOneAreaOneChoiceView: View {
    @ObservedObject private var viewModel: GenericViewModel
    let contexts: [ContextViewModel]
    @State private var scene = SKScene()

    public init(gameplay: any GameplayProtocol, contexts: [ContextViewModel]) {
        self.viewModel = GenericViewModel(gameplay: gameplay)
        self.contexts = contexts
    }

    public var body: some View {
        //        DragAndDropHostView(
        //            viewModel: viewModel,
        //            scene: $scene
        //        )
        GeometryReader { proxy in
            SpriteView(
                scene: makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onReceive(viewModel.$state) { state in
                switch state {
                    case .playing:
                        print(viewModel.choices[0].item, "playing")
                    case .finished:
                        print(viewModel.choices[0].item, "finished")
                    case .idle:
                        print(viewModel.choices[0].item, "idle")
                        scene = DragAndDropOneAreaOneChoiceScene(contexts: contexts)
                }
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func makeScene(size: CGSize) -> SKScene {
        guard let properScene = scene as? DragAndDropSceneProtocol else {
            return SKScene()
        }
        properScene.size = CGSize(width: size.width, height: size.height)
        properScene.viewModel = viewModel

        return properScene
    }
}
