// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

struct RemoteArrowView: View {
    let robot = Robot.shared

    var body: some View {
        CircleLayout {
            ArrowButton(arrow: .up) {
                self.robot.move(.forward(speed: 1))
                self.robot.shine(.all(in: ArrowButton.Arrow.up.color))
            } onReleased: {
                self.robot.stopMotion()
                self.robot.stopLights()
            }
            ArrowButton(arrow: .clockwise) {
                self.robot.move(.spin(.clockwise, speed: 1))
                self.robot.shine(.all(in: ArrowButton.Arrow.clockwise.color))
            } onReleased: {
                self.robot.stopMotion()
                self.robot.stopLights()
            }
            ArrowButton(arrow: .down) {
                self.robot.move(.backward(speed: 1))
                self.robot.shine(.all(in: ArrowButton.Arrow.down.color))
            } onReleased: {
                self.robot.stopMotion()
                self.robot.stopLights()
            }
            ArrowButton(arrow: .counterclockwise) {
                self.robot.move(.spin(.counterclockwise, speed: 1))
                self.robot.shine(.all(in: ArrowButton.Arrow.counterclockwise.color))
            } onReleased: {
                self.robot.stopMotion()
                self.robot.stopLights()
            }
        }
    }
}

#Preview {
    RemoteArrowView()
}
