// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class ActionBlink: RobotActionProtocol {
    // MARK: Lifecycle

    init(delay: Duration, duration: Duration, and parallelActions: [RobotAction] = []) {
        self.delay = delay
        self.duration = duration
        self.parallelActions = parallelActions

        self.task = Task {
            repeat {
                guard self.task?.isCancelled == false else { return }
                self.robot.shine(.all(in: .white))
                try await Task.sleep(for: self.delay)
                self.robot.shine(.all(in: .black))
                try await Task.sleep(for: self.delay)
                try Task.checkCancellation()
            } while !Task.isCancelled && self.isRunning
        }
    }

    // MARK: Internal

    var delay: Duration
    var duration: Duration
    var parallelActions: [RobotAction]

    var isRunning: Bool = false

    func execute() async throws {
        self.isRunning = true
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int(self.duration.components.seconds))) {
            log.debug("toggle is running to false")
            self.isRunning = false
        }
//        Task {
//            repeat {
//                guard self.task?.isCancelled == false else { return }
//                self.robot.shine(.all(in: .white))
//                try await Task.sleep(for: self.delay)
//                self.robot.shine(.all(in: .black))
//                try await Task.sleep(for: self.delay)
//                try Task.checkCancellation()
//            } while !Task.isCancelled && self.isRunning
//        }

        async let _ = self.task?.result
    }

    func end() {
        log.debug("blink - END")
        self.robot.stopLights()
    }

    func cancel() {
        self.isRunning = false
        self.task?.cancel()
        self.task = nil
        self.end()
    }

    // MARK: Private

    private var task: Task<Void, Error>?

    private var robot = Robot.shared
}
