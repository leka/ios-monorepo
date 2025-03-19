// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

// MARK: - NewHideAndSeekCoordinator

class NewHideAndSeekCoordinator: ExerciseSharedDataProtocol {
    var didComplete: PassthroughSubject<Void, Never> = .init()

    let reinforcers: [Robot.Reinforcer] = [.fire, .rainbow, .sprinkles]

    func completeHideAndSeek() {
        self.didComplete.send()
    }

    func wiggle(for duration: CGFloat) {
        guard duration > 0 else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Robot.shared.stopMotion()
            }
            return
        }
        let motionDuration = 0.2

        DispatchQueue.main.asyncAfter(deadline: .now() + motionDuration) {
            Robot.shared.move(.spin(.clockwise, speed: 1))

            DispatchQueue.main.asyncAfter(deadline: .now() + motionDuration) {
                Robot.shared.move(.spin(.counterclockwise, speed: 1))
                self.wiggle(for: duration - motionDuration * 2)
            }
        }
    }

    func runRandomReinforcer() {
        Robot.shared.run(self.reinforcers.randomElement()!)
    }
}

#Preview {
    let coordinator = NewHideAndSeekCoordinator()
    let viewModel = NewHideAndSeekViewViewModel(coordinator: coordinator)

    return NewHideAndSeekView(viewModel: viewModel)
}
