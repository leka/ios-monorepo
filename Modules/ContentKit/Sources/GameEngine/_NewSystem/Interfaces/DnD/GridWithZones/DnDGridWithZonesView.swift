// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
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
        ZStack(alignment: .bottomTrailing) {
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
                            self.scene = DnDGridWithZonesBaseScene(viewModel: self.viewModel)
                        }
                }
                .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                .allowsHitTesting(self.viewModel.didTriggerAction)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if self.viewModel.validationState != .hidden {
                Button {
                    self.viewModel.onValidate()
                } label: {
                    Text(l10n.ExerciseView.validateButtonLabel)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 100, height: 25)
                        .padding()
                        .background(
                            Capsule()
                                .fill(self.viewModel.validationState == .enabled ? .cyan : .gray.opacity(0.3))
                                .shadow(radius: 1)
                        )
                }
                .animation(.easeOut(duration: 0.3), value: self.viewModel.validationState)
                .disabled(self.viewModel.validationState == .disabled)
                .padding()
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
