// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// MARK: - DnDGridWithZonesView

public struct DnDGridWithZonesView: View {
    // MARK: Lifecycle

    init(viewModel: DnDGridWithZonesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(scene: self.makeScene(size: proxy.size), options: [.allowsTransparency])
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onAppear {
                    self.scene = DnDGridWithZonesBaseScene(viewModel: self.viewModel)
                }
        }
    }

    // MARK: Private

    @StateObject private var viewModel: DnDGridWithZonesViewModel
    @State private var scene: SKScene = .init()

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DnDGridWithZonesBaseScene else {
            return SKScene()
        }
        finalScene.size = size
        return finalScene
    }
}
