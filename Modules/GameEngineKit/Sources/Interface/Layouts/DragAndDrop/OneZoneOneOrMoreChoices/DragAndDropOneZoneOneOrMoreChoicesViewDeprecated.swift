// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

public struct DragAndDropOneZoneOneOrMoreChoicesViewDeprecated: View {
    @StateObject private var viewModel: DragAndDropZoneViewModel
    @State private var scene: SKScene = SKScene()
    let hints: Bool

    public init(gameplay: any DragAndDropGameplayProtocol, hints: Bool) {
        self._viewModel = StateObject(wrappedValue: DragAndDropZoneViewModel(gameplay: gameplay))
        self.hints = hints
    }

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                scene = DragAndDropOneZoneOneOrMoreChoicesSceneDeprecated(viewModel: viewModel, hints: hints)
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DragAndDropBaseSceneDeprecated else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = viewModel
        return finalScene
    }
}
