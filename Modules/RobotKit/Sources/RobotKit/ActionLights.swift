// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class ActionLights: RobotActionProtocol {
    // MARK: Lifecycle

    init(_ lights: Robot.Lights, duration: Duration, and parallelActions: [RobotAction] = []) {
        self.lights = lights
        self.duration = duration
        self.parallelActions = parallelActions
    }

    // MARK: Internal

    var lights: Robot.Lights
    var duration: Duration
    var parallelActions: [RobotAction]
    var isRunning: Bool = false

    func execute() {
        self.robot.shine(self.lights)
        self.isRunning = true
    }

    func stop() {
        self.robot.stopLights()
        self.isRunning = false
    }

    // MARK: Private

    private let robot = Robot.shared
}
