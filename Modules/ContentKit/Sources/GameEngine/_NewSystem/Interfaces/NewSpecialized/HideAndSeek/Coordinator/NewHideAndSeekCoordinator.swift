// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

// MARK: - NewHideAndSeekCoordinator

class NewHideAndSeekCoordinator: ExerciseSharedDataProtocol {
    // MARK: Public

    public var didComplete: PassthroughSubject<ExerciseCompletionData?, Never> = .init()

    // MARK: Internal

    func completeHideAndSeek() {
        // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            logGEK.debug("Exercise completed")
            self.didComplete.send(self.completionData)
        }
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

    // MARK: Private

    private let reinforcers: [Robot.Reinforcer] = [.fire, .rainbow, .sprinkles]

    // TODO: (@ladislas, @HPezz) Add completion data for light or motion guidance for instance
    private var completionData: ExerciseCompletionData = .init()
}

// MARK: ExerciseEvaluationStrategy

extension NewHideAndSeekCoordinator: ExerciseEvaluationStrategy {
    public func evaluate(in _: EvaluationContext = .practice) -> ExerciseEvaluationLevel {
        .notApplicable
    }
}

#Preview {
    let coordinator = NewHideAndSeekCoordinator()
    let viewModel = NewHideAndSeekViewViewModel(coordinator: coordinator)

    return NewHideAndSeekView(viewModel: viewModel)
}
