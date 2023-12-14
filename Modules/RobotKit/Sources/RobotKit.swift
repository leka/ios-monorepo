// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - RobotActionProtocol

// swiftlint:disable force_try

// TODO: (@ladislas) add parallel actions
public protocol RobotActionProtocol {
    var isRunning: Bool { get }
    var duration: Duration { get set }

    func execute()
    func stop()
}

// MARK: - ActionMoveForward

final class ActionMoveForward: RobotActionProtocol {
    // MARK: Lifecycle

    init(speed: Float, duration: Duration) {
        self.speed = speed
        self.duration = duration
    }

    // MARK: Public

    public var speed: Float
    public var duration: Duration
    public var isRunning: Bool = false

    // MARK: Internal

    func execute() {
        self.robot.move(.forward(speed: 1))
        self.isRunning = true
    }

    func stop() {
        self.robot.stopMotion()
        self.isRunning = false
    }

    // MARK: Private

    private let robot = Robot.shared
}

// MARK: - ActionBlink

final class ActionBlink: RobotActionProtocol {
    // MARK: Lifecycle

    init(delay: Duration, duration: Duration) {
        self.delay = delay
        self.duration = duration
    }

    // MARK: Internal

    var delay: Duration
    var duration: Duration

    var isRunning: Bool = false

    func execute() {
        self.isRunning = true
        Task {
            while self.isRunning {
                self.robot.shine(.all(in: .white))
                try? await Task.sleep(for: self.delay)
                self.robot.shine(.all(in: .black))
                try? await Task.sleep(for: self.delay)
            }
        }
    }

    func stop() {
        self.isRunning = false
    }

    // MARK: Private

    private var robot = Robot.shared
}

// MARK: - ActionStopMotion

public final class ActionStopMotion: RobotActionProtocol {
    // MARK: Lifecycle

    init(duration: Duration) {
        self.duration = duration
    }

    // MARK: Public

    public var duration: Duration
    public var isRunning: Bool = false

    public func execute() {
        self.robot.stopMotion()
        self.isRunning = true
    }

    public func stop() {
        self.robot.stopMotion()
        self.isRunning = false
    }

    // MARK: Private

    private let robot = Robot.shared
}

// MARK: - RobotAction

public enum RobotAction {
    case moveForward(speed: Float, duration: Duration)
    case stopMotion(duration: Duration)
    case blink(delay: Duration, duration: Duration)

    // MARK: Public

    public var object: RobotActionProtocol {
        switch self {
            case let .moveForward(speed, duration):
                ActionMoveForward(speed: speed, duration: duration)
            case let .stopMotion(duration):
                ActionStopMotion(duration: duration)
            case let .blink(delay, duration):
                ActionBlink(delay: delay, duration: duration)
        }
    }
}

// MARK: - RobotKit

public class RobotKit {
    // MARK: Lifecycle

    private init() {}

    // MARK: Public

    public static var shared: RobotKit = .init()

    public func append(actions: RobotAction...) {
        for action in actions {
            self.actions.append(action.object)
        }
    }

    public func append(actions: [RobotAction]) {
        self.actions = actions.map(\.object)
    }

    public func execute() {
        for action in self.actions {
            action.execute()
        }
    }

    public func executeSync() {
        guard self.task == nil else {
            log.trace("Task already running, ignoring new execution")
            return
        }

        self.task = Task {
            for action in self.actions {
                guard self.task?.isCancelled == false else { return }

                action.execute()

                try? await Task.sleep(for: action.duration)
            }

            self.stop()
        }
    }

    public func stop() {
        self.task?.cancel()
        self.task = nil
        for action in self.actions {
            action.stop()
        }
        self.actions = []
        self.robot.stop()
    }

    // MARK: Private

    private let robot = Robot.shared

    private var actions: [RobotActionProtocol] = []
    private var task: Task<Void, Never>?
}

// swiftlint:enable force_try
