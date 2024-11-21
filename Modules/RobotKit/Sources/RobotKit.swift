// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class RobotKit {
    // MARK: Lifecycle

    private init() {}

    // MARK: Public

    public static var shared: RobotKit = .init()

    public func append(actions: [RobotAction]) {
        self.actions = actions
    }

    public func executeSync() {
        guard self.task == nil else {
            log.trace("Task already running, ignoring new execution")
            return
        }

        self.task = Task {
            for action in self.actions {
                guard self.task?.isCancelled == false else {
                    log.debug("Task cancelled, stopping robot kit")
                    return
                }

                self.currentAction = action
                log.debug("execute action \(action)")
                try await action.object.execute()
//                async let _ = action.object.execute()
                log.debug("execute action \(action) ✅")
            }
            self.terminate()
        }
    }

    public func cancel() {
        log.debug("cancel sequence")

        self.currentAction?.object.cancel()
        self.task?.cancel()

        self.currentAction = nil
        self.task = nil

        self.terminate()
    }

    public func terminate() {
        log.debug("terminate sequence")
        self.task?.cancel()
        self.task = nil
        self.actions = []
        self.robot.stop()
    }

    // MARK: Private

    private let robot = Robot.shared

    private var actions: [RobotAction] = []
    private var currentAction: RobotAction?
    private var task: Task<Void, Error>?
}
