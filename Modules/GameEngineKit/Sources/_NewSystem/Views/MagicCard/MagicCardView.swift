// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
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
        VStack(alignment: .center) {
            Text(l10n.MagicCardView.instructions)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            HStack(spacing: 0) {
                Spacer()

                Button {
                    // nothing to do
                }
                label: {
                    ActionButtonView(action: self.viewModel.action)
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

                Spacer()

                Divider()
                    .opacity(0.4)
                    .frame(maxHeight: 500)
                    .padding(.vertical, 20)

                Spacer()

                Image(uiImage: DesignKitAsset.Images.robotMagicCard.image)
                    .resizable()
                    .frame(width: 300, height: 300)

                Spacer()
            }

            Spacer()

            Button {
                self.viewModel.onValidateCorrectAnswer()
            } label: {
                Text(l10n.ExerciseView.validateCorrectAnswerButtonLabel)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(height: 30)
                    .padding()
                    .background(
                        Capsule()
                            .fill(.orange)
                            .shadow(radius: 1)
                    )
            }
            .padding(20)
        }
        .onDisappear {
            Robot.shared.stopLights()
            Robot.shared.displayDefaultWorkingFace()
        }
    }

    // MARK: Private

    @StateObject private var viewModel: MagicCardViewViewModel
}

// MARK: - l10n.MagicCardView

extension l10n {
    enum MagicCardView {
        static let instructions = LocalizedString("game_engine_kit.magic_card_view.instructions",
                                                  bundle: GameEngineKitResources.bundle,
                                                  value: """
                                                      Bring the magic card to the robot's forehead
                                                      to validate the answer.
                                                      """,
                                                  comment: "MagicCardView instructions")
    }
}

#Preview {
    // MARK: - MagicCardEmptyCoordinator

    class MagicCardEmptyCoordinator: MagicCardGameplayCoordinatorProtocol {
        var action = Exercise.Action.robot(type: .image("robotFaceDisgusted"))
        func enableMagicCardDetection() {}
        func validateCorrectAnswer() {}
    }

    let coordinator = MagicCardEmptyCoordinator()
    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

    return MagicCardView(viewModel: viewModel)
}
