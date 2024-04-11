// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

// TODO(@ladislas): decide where to put this, keeping it here for now
public extension Robot.Reinforcer {
    func icon() -> Image {
        switch self {
            case .spinBlinkGreenOff:
                DesignKitAsset.Reinforcers.spinBlinkGreenOff.swiftUIImage
            case .spinBlinkBlueViolet:
                DesignKitAsset.Reinforcers.spinBlinkBlueViolet.swiftUIImage
            case .fire:
                DesignKitAsset.Reinforcers.fire.swiftUIImage
            case .sprinkles:
                DesignKitAsset.Reinforcers.sprinkles.swiftUIImage
            case .rainbow:
                DesignKitAsset.Reinforcers.rainbow.swiftUIImage
        }
    }
}

// MARK: - ReinforcerButton

struct ReinforcerButton: View {
    var reinforcer: Robot.Reinforcer
    let robot = Robot.shared

    var body: some View {
        Button {
            self.robot.run(self.reinforcer)
        } label: {
            self.reinforcer.icon()
        }
    }
}

#Preview {
    ReinforcerButton(reinforcer: .fire)
}
