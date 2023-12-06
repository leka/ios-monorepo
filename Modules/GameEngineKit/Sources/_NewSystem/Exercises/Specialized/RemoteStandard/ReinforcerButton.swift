// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

// TODO(@ladislas): decide where to put this, keeping it here for now
public extension Robot.Reinforcer {
    func icon() -> Image {
        switch self {
            case .spinBlinkGreenOff:
                return DesignKitAsset.Reinforcers.spinBlinkGreenOff.swiftUIImage
            case .spinBlinkBlueViolet:
                return DesignKitAsset.Reinforcers.spinBlinkBlueViolet.swiftUIImage
            case .fire:
                return DesignKitAsset.Reinforcers.fire.swiftUIImage
            case .sprinkles:
                return DesignKitAsset.Reinforcers.sprinkles.swiftUIImage
            case .rainbow:
                return DesignKitAsset.Reinforcers.rainbow.swiftUIImage
        }
    }
}

// MARK: - ReinforcerButton

struct ReinforcerButton: View {
    var reinforcer: Robot.Reinforcer
    let robot = Robot.shared

    var body: some View {
        Button {
            robot.run(reinforcer)
        } label: {
            reinforcer.icon()
        }
    }
}

#Preview {
    ReinforcerButton(reinforcer: .fire)
}
