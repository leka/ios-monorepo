// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// MARK: - DnDGridView

public struct DnDGridView: View {
    // MARK: Lifecycle

    public init(viewModel: DnDGridViewModel) {
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
                                self.viewModel.didTriggerAction = true
                            }
                        }
                )

                Divider()
                    .opacity(0.4)
                    .frame(maxHeight: 500)
                    .padding(.vertical, 20)
            }

            GeometryReader { proxy in
                SpriteView(scene: self.makeScene(size: proxy.size), options: [.allowsTransparency])
                    .onAppear {
                        self.scene = self.getScene(for: self.viewModel.choices.count)
                    }
            }
            .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
            .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
            .allowsHitTesting(self.viewModel.didTriggerAction)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: Private

    @StateObject private var viewModel: DnDGridViewModel
    @State private var scene: SKScene = .init()

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DnDGridBaseScene else {
            return SKScene()
        }
        finalScene.size = size
        return finalScene
    }

    private func getScene(for choiceCount: Int) -> SKScene {
        switch choiceCount {
            case 2:
                DnDGridTwoChoicesScene(viewModel: self.viewModel)
            case 3:
                DnDGridThreeChoicesScene(viewModel: self.viewModel)
            case 4:
                DnDGridFourChoicesScene(viewModel: self.viewModel)
            case 5:
                DnDGridFiveChoicesScene(viewModel: self.viewModel)
            case 6:
                DnDGridSixChoicesScene(viewModel: self.viewModel)
            default:
                DnDGridBaseScene(viewModel: self.viewModel)
        }
    }
}
