// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension DiscoverLekaView {
    enum Animation: CaseIterable {
        case quickMove
        case spin
        case headNod
        case headShake
        case reinforcer
        case light

        // MARK: Internal

        func actions() -> [(TimeInterval, () -> Void)] {
            switch self {
                case .quickMove:
                    let rotation = [Robot.Motion.Rotation.counterclockwise, Robot.Motion.Rotation.clockwise]
                    return [
                        (0.3, { Robot.shared.move(.spin(rotation.randomElement()!, speed: 0.6)) }),
                        (0.0, { Robot.shared.stopMotion() }),
                    ]
                case .spin:
                    let rotation = [Robot.Motion.Rotation.counterclockwise, Robot.Motion.Rotation.clockwise]
                    return [
                        (2.2, { Robot.shared.move(.spin(rotation.randomElement()!, speed: 0.6)) }),
                        (0.0, { Robot.shared.stopMotion() }),
                    ]
                case .headNod:
                    return [
                        (0.2, { Robot.shared.move(.forward(speed: 0.3)) }),
                        (0.3, { Robot.shared.move(.backward(speed: 0.3)) }),
                        (0.2, { Robot.shared.move(.forward(speed: 0.3)) }),
                        (0.0, { Robot.shared.stopMotion() }),
                    ]
                case .headShake:
                    return [
                        (0.1, { Robot.shared.move(.spin(.clockwise, speed: 0.5)) }),
                        (0.15, { Robot.shared.move(.spin(.counterclockwise, speed: 0.5)) }),
                        (0.1, { Robot.shared.move(.spin(.clockwise, speed: 0.5)) }),
                        (0.1, { Robot.shared.move(.spin(.counterclockwise, speed: 0.5)) }),
                        (0.0, { Robot.shared.stopMotion() }),
                    ]
                case .reinforcer:
                    let reinforcers: [Robot.Reinforcer] = [.fire, .rainbow, .sprinkles]
                    return [
                        (5.0, { Robot.shared.run(reinforcers.randomElement()!) }),
                    ]
                case .light:
                    let color: [Robot.Color] = [.blue, .green, .orange, .pink, .purple, .red, .yellow]
                    return [
                        (3.0, { Robot.shared.shine(.all(in: color.randomElement()!)) }),
                        (0.1, { Robot.shared.stopLights() }),
                    ]
            }
        }

        func duration() -> TimeInterval {
            self.actions().reduce(0) { total, action in
                total + action.0
            }
        }
    }
}
