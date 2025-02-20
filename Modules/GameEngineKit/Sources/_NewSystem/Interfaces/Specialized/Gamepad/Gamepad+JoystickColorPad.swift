// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

enum Gamepad {
    enum DisplayMode: String, CaseIterable {
        case fullBelt
        case twoHalves
        case fourQuarters
    }

    struct RadialLayout: Layout {
        var firstButtonPosX: Int
        var firstButtonPosY: Int
        var angle: Double

        func sizeThatFits(proposal: ProposedViewSize, subviews _: Subviews, cache _: inout ()) -> CGSize {
            proposal.replacingUnspecifiedDimensions()
        }

        func placeSubviews(in bounds: CGRect, proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
            let angleDivision = Angle.degrees(self.angle / Double(subviews.count - 1)).radians
            let posX = bounds.midX
            let posY = bounds.midY * 5 / 4

            for (index, subview) in subviews.enumerated() {
                if index == 0 {
                    subview.place(
                        at: CGPoint(x: posX, y: posY), anchor: .center, proposal: .unspecified
                    )
                } else {
                    var point = CGPoint(x: firstButtonPosX, y: firstButtonPosY)
                        .applying(CGAffineTransform(rotationAngle: CGFloat(angleDivision) * CGFloat(index - 1)))

                    point.x += posX
                    point.y += posY

                    subview.place(at: point, anchor: .center, proposal: .unspecified)
                }
            }
        }
    }

    struct Joystick: View {
        // MARK: Internal

        var body: some View {
            HStack(spacing: 400) {
                RadialLayout(firstButtonPosX: -100, firstButtonPosY: -250, angle: 120.0) {
                    JoystickView()

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
    Gamepad.Joystick()
}
