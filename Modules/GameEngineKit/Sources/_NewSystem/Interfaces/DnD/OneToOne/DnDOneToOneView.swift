// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SpriteKit
import SwiftUI

// MARK: - DnDOneToOneView

public struct DnDOneToOneView: View {
    // MARK: Lifecycle

    public init(viewModel: DnDOneToOneViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        VStack(alignment: .center) {
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

                Spacer()

                GeometryReader { proxy in
                    SpriteView(scene: self.makeScene(size: proxy.size), options: [.allowsTransparency])
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .onAppear {
                            self.scene = DnDOneToOneBaseScene(viewModel: self.viewModel)
                        }
                }
                .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                .allowsHitTesting(self.viewModel.didTriggerAction)

                Spacer()
            }

            // TODO: (@HPezz) Change into manual/automatic enum
            if let validationEnabled = self.viewModel.validationEnabled {
                Button {
                    self.viewModel.onValidate()
                } label: {
                    Text(l10n.ExerciseView.validateButtonLabel)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 100, height: 30)
                        .padding()
                        .background(
                            Capsule()
                                .fill(validationEnabled ? .green : .gray.opacity(0.3))
                                .shadow(radius: 1)
                        )
                }
                .animation(.easeOut(duration: 0.3), value: validationEnabled)
                .disabled(!validationEnabled)
                .padding(20)
            }
        }
    }

    // MARK: Private

    @StateObject private var viewModel: DnDOneToOneViewModel
    @State private var scene: SKScene = .init()

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DnDOneToOneBaseScene else {
            return SKScene()
        }
        finalScene.size = size
        return finalScene
    }
}
