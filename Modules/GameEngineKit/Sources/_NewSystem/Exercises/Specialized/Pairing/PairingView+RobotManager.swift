// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

extension PairingView {
    class RobotManager {
        // MARK: Internal

        func startPairing() {
            self.isAnimationRunning = true
            self.runRandomAnimation()
        }

        func pausePairing() {
            self.isAnimationRunning = false
            self.robot.stopMotion()
        }

        func stopPairing() {
            self.isAnimationRunning = false
            self.robot.stop()
            self.lightIntensity = 0.0
        }

        // MARK: Private

        private var isAnimationRunning: Bool = false
        private var isBreathing: Bool = false
        private var breatheIn = true
        private var lightIntensity: Float = 0.0
        private var animationTime: TimeInterval = 0.0
        private let lightIntensityChangeDuration = 0.05
        private let robot = Robot.shared

        private func runRandomAnimation() {
            guard self.isAnimationRunning else { return }

            let randomInterval = Double.random(in: 5.0...10.0)
            self.isBreathing = true
            self.breathe()

            DispatchQueue.main.asyncAfter(deadline: .now() + randomInterval) {
                guard self.isAnimationRunning else { return }
                self.isBreathing = false
                let currentAnimation = Animation.allCases.randomElement()!
                self.play(currentAnimation)

                DispatchQueue.main.asyncAfter(deadline: .now() + currentAnimation.duration()) {
                    guard self.isAnimationRunning else { return }
                    self.runRandomAnimation()
                }
            }
        }

        private func play(_ animation: Animation) {
            let actions = animation.actions()
            self.animationTime = 0.1

            for (duration, action) in actions {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationTime) {
                    guard self.isAnimationRunning else { return }
                    action()
                }
                self.animationTime += duration
            }
        }

        private func breathe() {
            guard self.isAnimationRunning, self.isBreathing else { return }

            self.updateLightIntensity()

            DispatchQueue.main.asyncAfter(deadline: .now() + self.lightIntensityChangeDuration) {
                let shadeOfColor: Robot.Color = .init(fromGradient: (.black, .lightBlue), at: self.lightIntensity)
                self.robot.shine(.all(in: shadeOfColor))
                self.breathe()
            }
        }

        private func updateLightIntensity() {
            if self.lightIntensity >= 1.0 {
                self.breatheIn = false
            } else if self.lightIntensity <= 0.0 {
                self.breatheIn = true
            }

            self.lightIntensity += self.breatheIn ? 0.02 : -0.02
        }
    }
}
