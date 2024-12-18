// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// MARK: - DnDGridWithZonesView

public struct DnDGridWithZonesView: View {
    // MARK: Lifecycle

    public init(viewModel: DnDGridWithZonesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            if let action = self.viewModel.action {
                Button {
                    // nothing to do
                }
                label: {
                    ActionButtonView(action: action)
                        .padding(20)
                }
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            withAnimation {
                                self.viewModel.isActionTriggered = true
                            }
                        }
                )

                Divider()
                    .opacity(0.4)
                    .frame(maxHeight: 500)
                    .padding(.vertical, 20)
            }

            Spacer()

            GeometryReader { proxy in
                SpriteView(scene: self.makeScene(size: proxy.size), options: [.allowsTransparency])
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .onAppear {
                        self.scene = DnDGridWithZonesBaseScene(viewModel: self.viewModel)
                    }
            }
            .colorMultiply(self.viewModel.isActionTriggered ? .white : .gray.opacity(0.4))
            .animation(.easeOut(duration: 0.3), value: self.viewModel.isActionTriggered)
            .allowsHitTesting(self.viewModel.isActionTriggered)

            Spacer()
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
