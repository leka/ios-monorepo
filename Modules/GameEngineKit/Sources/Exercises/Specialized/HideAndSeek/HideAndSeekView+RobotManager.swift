// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

extension HideAndSeekView {
    class RobotManager {
        let reinforcers: [Robot.Reinforcer] = [.fire, .rainbow, .sprinkles]
        let robot = Robot.shared

        func wiggle(for duration: CGFloat) {
            guard duration > 0 else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.robot.stopMotion()
                }
                return
            }
            log.trace("🤖 WIGGLE for \(duration) seconds")
            let motionDuration = 0.2

            DispatchQueue.main.asyncAfter(deadline: .now() + motionDuration) {
                self.robot.move(.spin(.clockwise, speed: 1))

                DispatchQueue.main.asyncAfter(deadline: .now() + motionDuration) {
                    self.robot.move(.spin(.counterclockwise, speed: 1))
                    self.wiggle(for: duration - motionDuration * 2)
                }
            }
        }

        func runRandomReinforcer() {
            self.robot.run(self.reinforcers.randomElement()!)
        }
    }
}
