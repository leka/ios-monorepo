// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

extension DiscoverLekaView {
    class RobotManager {
        // MARK: Lifecycle

        init(data: ExerciseSharedData, demoMode: Bool = false) {
            self.shared = data
            self.animations = demoMode ? [.reinforcer, .light] : Animation.allCases
        }

        // MARK: Internal

        let shared: ExerciseSharedData

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
        private var animations: [Animation]

        private func runRandomAnimation() {
            guard self.isAnimationRunning, !self.shared.isCompleted else { return }

            let randomInterval = Double.random(in: 10.0...15.0)
            self.isBreathing = true
            self.breathe()

            DispatchQueue.main.asyncAfter(deadline: .now() + randomInterval) {
                guard self.isAnimationRunning, !self.shared.isCompleted else { return }
                self.isBreathing = false
                let currentAnimation = self.animations.randomElement()!
                self.play(currentAnimation)

                DispatchQueue.main.asyncAfter(deadline: .now() + currentAnimation.duration()) {
                    guard self.isAnimationRunning, !self.shared.isCompleted else { return }
                    self.runRandomAnimation()
                }
            }
        }

        private func play(_ animation: Animation) {
            let actions = animation.actions()
            self.animationTime = 0.1

            for (duration, action) in actions {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationTime) {
                    guard self.isAnimationRunning, !self.shared.isCompleted else { return }
                    action()
                }
                self.animationTime += duration
            }
        }

        private func breathe() {
            guard self.isAnimationRunning, self.isBreathing, !self.shared.isCompleted else { return }

            self.updateLightIntensity()

            DispatchQueue.main.asyncAfter(deadline: .now() + self.lightIntensityChangeDuration) {
                guard self.isAnimationRunning, self.isBreathing, !self.shared.isCompleted else { return }

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
