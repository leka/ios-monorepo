// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

extension DanceFreeze {
    class RobotManager {
        let robot = Robot.shared
        var lastMove = 0

        func stopRobot() {
            robot.blacken(.all)
            robot.stopMotion()
        }

        func freeze() {
            robot.shine(.all(in: .white))
            robot.stopMotion()
        }

        func shineRandomly() {
            let randomColor = getRandomColor()
            let randomLight = getRandomLight(color: randomColor)

            robot.shine(randomLight)
        }

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
            lastMove += 1

            let action = motions[lastMove % motions.count]
            robot.move(action.motion)

            return action.duration
        }

        func movementDance() -> CGFloat {
            let motions: [(duration: CGFloat, motion: Robot.Motion)] = [
                (2, .forward(speed: 1)), (3, .spin(.clockwise, speed: 1)),
                (2, .forward(speed: 1)), (3, .spin(.counterclockwise, speed: 1)),
            ]
            lastMove += 1

            let action = motions[lastMove % motions.count]
            robot.move(action.motion)

            return action.duration
        }
    }
}
