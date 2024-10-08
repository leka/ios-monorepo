// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// MARK: - DnDView

public struct DnDView: View {
    // MARK: Lifecycle

    init(viewModel: DnDViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(scene: self.makeScene(size: proxy.size), options: [.allowsTransparency])
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onAppear {
                    self.scene = self.getScene(for: self.viewModel.choices.count, size: proxy.size)
                }
        }
    }

    // MARK: Private

    @StateObject private var viewModel: DnDViewViewModel
    @State private var scene: SKScene = .init()

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DnDBaseScene else {
            return SKScene()
        }
        finalScene.size = size
        return finalScene
    }

    private func getScene(for choiceCount: Int, size _: CGSize) -> SKScene {
        switch choiceCount {
            case 6:
                SixChoicesScene(viewModel: self.viewModel)
            default:
                DnDBaseScene(viewModel: self.viewModel)
        }
    }
}