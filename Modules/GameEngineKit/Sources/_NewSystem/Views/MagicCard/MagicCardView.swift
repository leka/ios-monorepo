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
        VStack {
            Text(l10n.MagicCardView.instructions)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 100)

            Spacer()

            Button {
                // nothing to do
            }
            label: {
                ActionButtonView(action: self.viewModel.action, scale: 2)
                    .padding(20)
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
    }

    let coordinator = MagicCardEmptyCoordinator()
    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

    return MagicCardView(viewModel: viewModel)
}
