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
                robot.move(.forward(speed: 1))
                robot.shine(.all(in: ArrowButton.Arrow.up.color))
            } onReleased: {
                robot.stopMotion()
                robot.stopLights()
            }
            ArrowButton(arrow: .clockwise) {
                robot.move(.spin(.clockwise, speed: 1))
                robot.shine(.all(in: ArrowButton.Arrow.clockwise.color))
            } onReleased: {
                robot.stopMotion()
                robot.stopLights()
            }
            ArrowButton(arrow: .down) {
                robot.move(.backward(speed: 1))
                robot.shine(.all(in: ArrowButton.Arrow.down.color))
            } onReleased: {
                robot.stopMotion()
                robot.stopLights()
            }
            ArrowButton(arrow: .counterclockwise) {
                robot.move(.spin(.counterclockwise, speed: 1))
                robot.shine(.all(in: ArrowButton.Arrow.counterclockwise.color))
            } onReleased: {
                robot.stopMotion()
                robot.stopLights()
            }
        }
    }
}

#Preview {
    RemoteArrowView()
}
