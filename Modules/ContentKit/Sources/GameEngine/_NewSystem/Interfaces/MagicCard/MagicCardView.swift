// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - MagicCardView

public struct MagicCardView: View {
    // MARK: Lifecycle

    public init(viewModel: MagicCardViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                if let action = self.viewModel.action {
                    Button {
                        // nothing to do
                    }
                    label: {
                        ActionButtonView(action: action)
                            .frame(width: 300, height: 300)
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { _ in
                                withAnimation {
                                    self.viewModel.didTriggerAction = true
                                    self.viewModel.enableMagicCardDetection()
                                }
                            }
                    )
                }

                Divider()
                    .opacity(0.4)
                    .frame(maxHeight: 500)
                    .padding(.vertical, 20)

                Image(uiImage: DesignKitAsset.Images.robotMagicCard.image)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Button {
                self.viewModel.onValidateCorrectAnswer()
                self.isCorrectAnswerButtonPresented = false
            } label: {
                Text(l10n.MagicCardView.correctAnswerButtonLabel)
                    .font(.title2.bold())
                    .frame(maxWidth: 400, maxHeight: 40)
                    .padding()
                    .overlay(
                        Capsule().stroke(.cyan, lineWidth: 2)
                    )
            }
            .padding()
            .offset(x: 100)
            .disabled(self.viewModel.didTriggerAction == false)
            .opacity(self.isCorrectAnswerButtonPresented ? 1 : 0)
            .animation(.easeInOut(duration: 0.2).delay(0.75), value: self.isCorrectAnswerButtonPresented)
        }
        .onDisappear {
            Robot.shared.stopLights()
            Robot.shared.displayDefaultWorkingFace()
        }
    }

    // MARK: Private

    @StateObject private var viewModel: MagicCardViewViewModel
    @State private var isCorrectAnswerButtonPresented: Bool = true
}

// MARK: - l10n.MagicCardView

extension l10n {
    enum MagicCardView {
        static let correctAnswerButtonLabel = LocalizedString("game_engine_kit.magic_card_view.reinforcer",
                                                              bundle: ContentKitResources.bundle,
                                                              value: "✅ Validate & Play Reinforcer 🎉",
                                                              comment: "The button label to validate a correct answer")
    }
}

#Preview {
    // MARK: - MagicCardEmptyCoordinator

    class MagicCardEmptyCoordinator: MagicCardGameplayCoordinatorProtocol {
        var action: NewExerciseAction? = NewExerciseAction.robot(type: .image("robotFaceDisgusted"))
        func enableMagicCardDetection() {}
        func validateCorrectAnswer() {}
    }

    let coordinator = MagicCardEmptyCoordinator()
    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

    return MagicCardView(viewModel: viewModel)
}
