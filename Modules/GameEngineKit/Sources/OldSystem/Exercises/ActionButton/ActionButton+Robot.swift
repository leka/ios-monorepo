// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - ActionButtonRobot

struct ActionButtonRobot: View {
    // MARK: Lifecycle

    init(actionType: Exercise.Action.ActionType, robotWasTapped: Binding<Bool>) {
        self.actionType = actionType
        self._robotWasTapped = robotWasTapped
    }

    // MARK: Internal

    let actionType: Exercise.Action.ActionType

    @Binding var robotWasTapped: Bool

    var body: some View {
        Button {
            switch self.actionType {
                case let .color(value):
                    Robot.shared.shine(.all(in: .init(from: value)))
                case let .image(name):
                    let robotAsset = RobotAssets.robotAsset(name: name)!
                    Robot.shared.display(imageID: robotAsset.id)
                case .audio,
                     .emoji,
                     .sfsymbol,
                     .speech:
                    log.error("Action not available for robot: \(self.actionType)")
                    fatalError("💥 Action not available for robot: \(self.actionType)")
            }

            withAnimation {
                self.robotWasTapped = true
            }
        } label: {
            Image(uiImage: DesignKitAsset.Images.robotFaceAction.image)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(self.styleManager.accentColor!)
                .frame(width: 130, height: 130)
                .padding(10)
        }
        .frame(width: 200)
        .disabled(self.robotWasTapped)
        .opacity(self.robotWasTapped ? 0.3 : 1.0)
        .buttonStyle(ActionButtonStyle(progress: 0.0))
        .animation(.spring(response: 0.3, dampingFraction: 0.45), value: self.robotWasTapped)
        .scaleEffect(self.robotWasTapped ? 0.95 : 1.0, anchor: .center)
        .shadow(
            color: .accentColor.opacity(0.2),
            radius: self.robotWasTapped ? 6 : 3, x: 0, y: 3
        )
    }

    // MARK: Private

    @StateObject private var styleManager: StyleManager = .shared
}

// MARK: - l10n.ActionButtonRobot

extension l10n {
    enum ActionButtonRobot {
        static let buttonLabel = LocalizedString("game_engine_kit.robot_then_touch_to_select.button_label",
                                                 bundle: GameEngineKitResources.bundle,
                                                 value: "Tap Leka",
                                                 comment: "Robot then touch to select button label")
    }
}

#Preview {
    struct ActionRobotButtonContainer: View {
        @State var robotWasTapped = false
        var body: some View {
            HStack {
                ActionButtonRobot(
                    actionType: .color("red"),
                    robotWasTapped: $robotWasTapped
                )

                ActionButtonListen(audio: .speech(text: "Hello"))
            }
        }
    }

    return ActionRobotButtonContainer()
}
