// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class ActionStop: RobotActionProtocol {
    // MARK: Lifecycle

    init(duration: Duration) {
        self.duration = duration
        self.parallelActions = []
    }

    // MARK: Internal

    var duration: Duration
    var parallelActions: [RobotAction]
    var isRunning: Bool = false

    func execute() {
        self.robot.stop()
        self.isRunning = true
    }

    func stop() {
        self.robot.stop()
        self.isRunning = false
    }

    // MARK: Private

    private let robot = Robot.shared
}
