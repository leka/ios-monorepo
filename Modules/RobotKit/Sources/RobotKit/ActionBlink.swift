// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

//
// final class ActionBlink: RobotActionProtocol {
//    // MARK: Lifecycle
//
//    init(delay: Duration, duration: Duration, and parallelActions: [RobotAction] = []) {
//        self.delay = delay
//        self.duration = duration
//        self.parallelActions = parallelActions
//    }
//
//    // MARK: Internal
//
//    var delay: Duration
//    var duration: Duration
//    var parallelActions: [RobotAction]
//
//    var isRunning: Bool = false
//
//    func execute() {
//        self.isRunning = true
//        Task {
//            // TODO: (@ladislas) NOT WORKING - count number of steps first
//            repeat {
//                guard self.task?.isCancelled == false else { return }
//                self.robot.shine(.all(in: .white))
//                try? await Task.sleep(for: self.delay)
//                self.robot.shine(.all(in: .black))
//                try? await Task.sleep(for: self.delay)
//            } while !Task.isCancelled && self.isRunning
//        }
//    }
//
//    func stop() {
//        log.debug("stop action blink")
//        self.isRunning = false
//        self.task?.cancel()
//        self.task = nil
//    }
//
//    // MARK: Private
//
//    private var task: Task<Void, Never>?
//
//    private var robot = Robot.shared
// }
