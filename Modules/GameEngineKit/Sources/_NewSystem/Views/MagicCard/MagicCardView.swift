// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import DesignKit
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
        HStack(spacing: 0) {
            Button {
                // nothing to do
            }
            label: {
                ActionButtonView(action: self.viewModel.action)
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

            Spacer()

            Image(uiImage: DesignKitAsset.Images.robotMagicCard.image)
                .resizable()
                .frame(width: 400, height: 400)
                .padding(10)

            Spacer()
        }
        .onDisappear {
            Robot.shared.stopLights()
            Robot.shared.clearDisplay()
        }
    }

    // MARK: Private

    @StateObject private var viewModel: MagicCardViewViewModel
}

#Preview {
    // MARK: - MagicCardEmptyCoordinator

    class MagicCardEmptyCoordinator: MagicCardGameplayCoordinatorProtocol {
        var action = Exercise.Action.robot(type: .image("robotFaceDisgusted"))
    }

    let coordinator = MagicCardEmptyCoordinator()
    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

    return MagicCardView(viewModel: viewModel)
}
