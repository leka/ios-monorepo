// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

extension DanceFreezeView {
    class RobotManager {
        // MARK: Internal

        let robot = Robot.shared
        var lastMove = 0

        func stopRobot() {
            self.robot.blacken(.all)
            self.robot.stopMotion()
        }

        func freeze() {
            self.robot.shine(.all(in: .white))
            self.robot.stopMotion()
        }

        func shineRandomly() {
            let randomColor = self.getRandomColor()
            let randomLight = self.getRandomLight(color: randomColor)

            self.robot.shine(randomLight)
        }

        func rotationDance() -> CGFloat {
            let motions: [(duration: CGFloat, motion: Robot.Motion)] = [
                (3, .spin(.clockwise, speed: 1)),
                (0.5, .stop),
                (3, .spin(.counterclockwise, speed: 1)),
                (0.5, .stop),
                (0.5, .spin(.clockwise, speed: 1)),
                (0.5, .spin(.counterclockwise, speed: 1)),
                (0.5, .spin(.clockwise, speed: 1)),
                (0.5, .spin(.counterclockwise, speed: 1)),
            ]
            self.lastMove += 1

            let action = motions[lastMove % motions.count]
            self.robot.move(action.motion)

            return action.duration
        }

        func movementDance() -> CGFloat {
            let motions: [(duration: CGFloat, motion: Robot.Motion)] = [
                (2, .forward(speed: 1)), (3, .spin(.clockwise, speed: 1)),
                (2, .forward(speed: 1)), (3, .spin(.counterclockwise, speed: 1)),
            ]
            self.lastMove += 1

            let action = motions[lastMove % motions.count]
            self.robot.move(action.motion)

            return action.duration
        }

        // MARK: Private

        private func getRandomColor() -> Robot.Color {
            let colors: [Robot.Color] = [.red, .blue, .green, .yellow, .lightBlue, .purple, .orange, .pink]
            return colors.randomElement()!
        }

        private func getRandomLight(color: Robot.Color) -> Robot.Lights {
            let lights: [Robot.Lights] = [
                .earLeft(in: color), .earRight(in: color), .quarterBackLeft(in: color), .quarterBackRight(in: color),
                .quarterFrontLeft(in: color), .quarterFrontRight(in: color),
            ]
            return lights.randomElement()!
        }
    }
}
