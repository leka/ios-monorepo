// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

public struct DragAndDropAssociationFourChoicesView: View {
    @StateObject private var viewModel: GenericViewModel
    @State private var scene: SKScene = SKScene()

    public init(gameplay: any GameplayProtocol) {
        self._viewModel = StateObject(wrappedValue: GenericViewModel(gameplay: gameplay))
    }

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                scene = DragAndDropAssociationFourChoicesScene(viewModel: viewModel)
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DragAndDropAssociationScene else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = viewModel
        return finalScene
    }
}
