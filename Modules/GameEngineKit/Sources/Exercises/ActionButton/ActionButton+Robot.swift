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
                case .audio,
                     .image,
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
            VStack {
                Image(uiImage: DesignKitAsset.Images.robotFaceSimple.image)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()

                Button(String(l10n.ActionButtonRobot.buttonLabel.characters)) {}
                    .font(.title)
                    .opacity(self.robotWasTapped ? 0.0 : 1.0)
                    .buttonStyle(.bordered)
                    .allowsHitTesting(false)
                    .tint(nil)
            }
        }
        .disabled(self.robotWasTapped)
        .opacity(self.robotWasTapped ? 0.3 : 1.0)
        .scaleEffect(self.robotWasTapped ? 0.95 : 1.0, anchor: .center)
    }
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
            ActionButtonRobot(
                actionType: .color("red"),
                robotWasTapped: $robotWasTapped
            )
        }
    }

    return ActionRobotButtonContainer()
}
