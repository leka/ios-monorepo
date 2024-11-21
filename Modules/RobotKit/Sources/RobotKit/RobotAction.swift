// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public enum RobotAction {
    case motion(Robot.Motion, duration: Duration, parallel: [RobotAction] = [])

    case blink(Duration, duration: Duration, parallel: [RobotAction] = [])
    //    case lights(Robot.Lights, duration: Duration, parallel: [RobotAction] = [])
//    case pause(duration: Duration)

    // MARK: Public

    public var object: RobotActionProtocol {
        switch self {
            case let .motion(motion, duration, parallel):
                ActionMotion(motion, duration: duration, and: parallel)
//            case let .lights(lights, duration, parallel):
//                ActionLights(lights, duration: duration, and: parallel)
            case let .blink(delay, duration, parallel):
                ActionBlink(delay: delay, duration: duration, and: parallel)
//            case let .pause(duration):
//                ActionStop(duration: duration)
        }
    }
}
