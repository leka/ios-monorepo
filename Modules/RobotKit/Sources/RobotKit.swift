// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class RobotKit {
    // MARK: Lifecycle

    private init() {}

    // MARK: Public

    public static var shared: RobotKit = .init()

//    public func append(actions: RobotAction...) {
//        for action in actions {
//            self.actions.append(action.object)
//        }
//    }

    public func append(actions: [RobotAction]) {
        self.actions = actions
    }

//    public func execute() {
//        for action in self.actions {
//            action.execute()
//        }
//    }

    public func executeSync() {
        guard self.task == nil else {
            log.trace("Task already running, ignoring new execution")
            return
        }

//        for action in self.actions {
//            log.debug("execute action \(action)")
//            await action.object.execute()
//            log.debug("execute action \(action) ✅")
//        }
        self.task = Task {
            for action in self.actions {
                guard self.task?.isCancelled == false else {
                    log.debug("Task cancelled, stopping robot kit")
                    //                    action.object.stop()
                    return
                }

                self.currentAction = action
                log.debug("execute action \(action)")
                async let _ = action.object.execute()
                //                async let currentTask: () = action.object.execute()
                //                await currentTask
                log.debug("execute action \(action) ✅")
            }
            self.stop()
        }

//        self.task = Task {
//            for action in self.actions {
//                guard self.task?.isCancelled == false else {
//                    log.debug("Task cancelled, stopping robot kit")
        ////                    action.object.stop()
//                    return
//                }
//                self.currentAction = action
//                log.debug("execute action \(action)")
//                await action.object.execute()
        ////                async let currentTask: () = action.object.execute()
        ////                await currentTask
//                log.debug("execute action \(action) ✅")
//            }
//            self.stop()
//        }
    }

//    public func executeSync() {
//        guard self.task == nil else {
//            log.trace("Task already running, ignoring new execution")
//            return
//        }
//
//        self.task = Task {
//            for action in self.actions {
//                guard self.task?.isCancelled == false else { return }
//                guard let action = action.object else {
//                    self.stop()
//                    return
//                }
//
//                action.execute()
//
//                action.parallelActions.forEach {
//                    guard let action = $0.object else { return }
//                    action.execute()
//                }
//
//                try? await Task.sleep(for: action.duration)
//
//                action.stop()
//                action.parallelActions.forEach {
//                    guard let action = $0.object else { return }
//                    action.stop()
//                }
//            }
//        }
//    }

    public func stop() {
        log.debug("stop robot kit")
//        self.actions[self.currentActionIndex].object.stop()

        self.task?.cancel()
//        self.currentAction?.object.cancel()
        self.task = nil
        self.currentAction = nil

//        for action in self.actions {
//            action.object.stop()
//            if let parallelActions = action.object.parallelActions {
//                for parallelAction in parallelActions {
//                    parallelAction.object.stop()
//                }
//            }
//        }
        self.actions = []

        self.robot.stop()
    }

    // MARK: Private

    private let robot = Robot.shared

    private var actions: [RobotAction] = []
    private var currentAction: RobotAction?
    private var task: Task<Void, Never>?
}
