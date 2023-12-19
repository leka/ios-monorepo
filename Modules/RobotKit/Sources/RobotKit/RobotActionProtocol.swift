// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol RobotActionProtocol {
    var isRunning: Bool { get }
    var duration: Duration { get }
    var parallelActions: [RobotAction] { get }

    func execute() async
    func end()
    func cancel()
}
