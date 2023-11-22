// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

struct ReinforcerButton: View {
    var reinforcer: Reinforcer
    let robot = Robot.shared

    var body: some View {
        Button {
            switch reinforcer {
                case .spinBlinkGreenOff:
                    robot.run(.spinBlinkGreenOff)
                case .spinBlinkBlueViolet:
                    robot.run(.spinBlinkBlueViolet)
                case .fire:
                    robot.run(.fire)
                case .sprinkles:
                    robot.run(.sprinkles)
                case .rainbow:
                    robot.run(.rainbow)
            }
        } label: {
            reinforcer.icon()
        }
    }
}

#Preview {
    ReinforcerButton(reinforcer: .fire)
}
