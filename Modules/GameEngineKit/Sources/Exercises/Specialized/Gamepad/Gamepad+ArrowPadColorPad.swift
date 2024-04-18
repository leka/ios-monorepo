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
                    LedZoneSelectorView(displayMode: self.displayMode)

                    ForEach(DisplayMode.allCases, id: \.self) { mode in
                        LedZoneSelectorView.ModeButton(mode: mode, displayMode: self.$displayMode)
                    }
                }
            }
        }

        // MARK: Private

        @State private var displayMode = DisplayMode.fullBelt
    }
}

#Preview {
    Gamepad.ArrowPadColorPad()
}
