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

        self.task = Task {
            guard Task.isCancelled == false else {
                log.debug("motion task is cancelled")
                return
            }
            log.debug("motion - start task - move")
            self.robot.move(self.motion)
            try await Task.sleep(for: self.duration)
            log.debug("motion - end task")
        }
    }

    // MARK: Internal

    var motion: Robot.Motion
    var duration: Duration
    var parallelActions: [RobotAction]

    var isRunning: Bool {
        self.task?.isCancelled == false
    }

    func execute() async throws {
//        log.debug("motion - before task")

//        self.task = Task {
//            guard Task.isCancelled == false else {
//                log.debug("motion task is cancelled")
//                return
//            }
//            log.debug("motion - start task - move")
//            self.robot.move(self.motion)
//            do {
//                log.debug("motion - start task - sleep")
//                try await Task.sleep(for: self.duration)
//                log.debug("motion - start task - sleep done")
//            } catch {
//                log.debug("error \(error)")
//            }
//            log.debug("motion - end task")
//        }

        async let _ = self.task?.result
//        log.debug("motion - after task")

//        let _ = await task
    }

    func end() {
        log.debug("motion - STOP")
        self.robot.stopMotion()
    }

    func cancel() {
        self.end()
        self.task?.cancel()
        self.task = nil
    }

    // MARK: Private

    private let robot = Robot.shared
    private var task: Task<Void, any Error>?
}
