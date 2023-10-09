// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

public struct DragAndDropOneAreaOneOrMoreChoicesView: View {
    @StateObject private var viewModel: GenericViewModel
    @State private var scene: SKScene = SKScene()
    var dropArea: DropAreaModel

    public init(gameplay: any GameplayProtocol, dropArea: DropAreaModel) {
        self._viewModel = StateObject(wrappedValue: GenericViewModel(gameplay: gameplay))
        self.dropArea = dropArea
    }

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                scene = DragAndDropOneAreaOneOrMoreChoicesScene(viewModel: viewModel, dropArea: dropArea)
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DragAndDropBaseScene else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = viewModel
        finalScene.dropAreas = [dropArea]
        return finalScene
    }
}
