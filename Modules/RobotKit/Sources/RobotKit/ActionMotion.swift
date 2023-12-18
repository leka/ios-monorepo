// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class ActionMotion: RobotActionProtocol {
    // MARK: Lifecycle

    init(_ motion: Robot.Motion, duration: Duration, and parallelActions: [RobotAction] = []) {
        self.motion = motion
        self.duration = duration
        self.parallelActions = parallelActions
    }

    // MARK: Internal

    var motion: Robot.Motion
    var duration: Duration
    var parallelActions: [RobotAction]
    var isRunning: Bool = false

    func execute() {
        self.robot.move(self.motion)
        self.isRunning = true
    }

    func stop() {
        self.robot.stopMotion()
        self.isRunning = false
    }

    // MARK: Private

    private let robot = Robot.shared
}
