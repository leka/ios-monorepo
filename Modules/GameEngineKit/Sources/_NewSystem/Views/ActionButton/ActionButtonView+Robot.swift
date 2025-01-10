// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - ActionButtonRobot

extension ActionButtonView {
    struct RobotButton: View {
        // MARK: Lifecycle

        init(actionType: Exercise.Action.RobotActionType) {
            self.actionType = actionType
        }

        // MARK: Internal

        @State var robotWasTapped: Bool = false

        let actionType: Exercise.Action.RobotActionType

        var body: some View {
            Button {
                switch self.actionType {
                    case let .color(value):
                        Robot.shared.shine(.all(in: .init(from: value)))
                    case let .image(name):
                        let robotAsset = RobotAssets.robotAsset(name: name)!
                        Robot.shared.display(imageID: robotAsset.id)
                    case let .flash(repetition):
                        Robot.shared.flashLight(repetitions: repetition)
                    case let .spots(numberOfSpots):
                        Robot.shared.shine(.randomBeltSpots(number: numberOfSpots))
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
            .buttonStyle(Style(progress: 0.0))
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
}

#Preview {
    struct ActionRobotButtonContainer: View {
        @State var robotWasTapped = false
        var body: some View {
            HStack {
                ActionButtonView.RobotButton(actionType: .color("red"))
            }
        }
    }

    return ActionRobotButtonContainer()
}
