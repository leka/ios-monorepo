// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

extension Gamepad {
    struct ArrowPadColorPad: View {
        // MARK: Internal

        var body: some View {
            HStack(spacing: 150) {
                RadialLayout(firstButtonPosX: -100, firstButtonPosY: -250, angle: 120.0) {
                    ArrowPadView(size: 110, xPosition: 110)

                    ForEach(Robot.Reinforcer.allCases, id: \.self) { reinforcer in
                        ReinforcerButton(reinforcer: reinforcer)
                    }
                }

                RadialLayout(firstButtonPosX: -120, firstButtonPosY: -200, angle: 90.0) {
                    ColorPad(displayMode: self.displayMode, padState: self.$padState)

                    ForEach(DisplayMode.allCases, id: \.self) { mode in
                        ColorPad.PadModeButton(mode: mode, displayMode: self.$displayMode, padState: self.$padState)
                    }
                }
            }
        }

        // MARK: Private

        @State private var displayMode = DisplayMode.fullBelt
        @State private var padState: ColorPad.PadState = .released
    }
}

#Preview {
    Gamepad.ArrowPadColorPad()
}
