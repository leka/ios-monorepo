// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

struct ArrowPadView: View {
    let robot = Robot.shared
    let size: CGFloat
    let xPosition: CGFloat

    var body: some View {
        CircleLayout(xPosition: self.xPosition) {
            ArrowButton(arrow: .up, size: self.size) {
                self.robot.move(.forward(speed: 1))
                self.robot.shine(.all(in: ArrowButton.Arrow.up.color))
            } onReleased: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.robot.stopMotion()
                    self.robot.stopLights()
                }
            }
            ArrowButton(arrow: .clockwise, size: self.size) {
                self.robot.move(.spin(.clockwise, speed: 1))
                self.robot.shine(.all(in: ArrowButton.Arrow.clockwise.color))
            } onReleased: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.robot.stopMotion()
                    self.robot.stopLights()
                }
            }
            ArrowButton(arrow: .down, size: self.size) {
                self.robot.move(.backward(speed: 1))
                self.robot.shine(.all(in: ArrowButton.Arrow.down.color))
            } onReleased: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.robot.stopMotion()
                    self.robot.stopLights()
                }
            }
            ArrowButton(arrow: .counterclockwise, size: self.size) {
                self.robot.move(.spin(.counterclockwise, speed: 1))
                self.robot.shine(.all(in: ArrowButton.Arrow.counterclockwise.color))
            } onReleased: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.robot.stopMotion()
                    self.robot.stopLights()
                }
            }
        }
    }
}

#Preview {
    ArrowPadView(size: 200, xPosition: 180)
}
