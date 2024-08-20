// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension ColorPad {
    struct EarButton: View {
        // MARK: Internal

        let selectedEar: Robot.Lights
        let robot = Robot.shared

        @Binding var padState: PadState

        var body: some View {
            Circle()
                .foregroundColor(self.selectedEar.color.screen)
                .frame(width: 50, height: 50)
                .onTapGesture {
                    self.buttonPressed.toggle()
                    if self.buttonPressed {
                        self.robot.shine(self.selectedEar)
                    } else {
                        self.robot.blacken(self.selectedEar)
                    }
                }
                .background(
                    Circle()
                        .foregroundColor(self.selectedEar.color.screen.opacity(0.5))
                        .frame(width: CGFloat(self.buttonPressed ? 65 : 0), height: CGFloat(self.buttonPressed ? 65 : 0))
                )
                .animation(.easeInOut(duration: 0.2), value: self.buttonPressed ? 65 : 0)
                // [] TODO: (@team) - Move to iOS17 support - Update the use of .onChange() modifier.
                // See below
                // .onChange(of: self.padState) { oldState, newState in
                //     if newState == .fullyPressed {
                //         self.buttonPressed = true
                //         self.robot.shine(self.selectedEar)
                //     } else {
                //         self.buttonPressed = false
                //         self.robot.blacken(self.selectedEar)
                //     }
                // }
                .onChange(of: self.padState) { state in
                    if state == .fullyPressed {
                        self.buttonPressed = true
                        self.robot.shine(self.selectedEar)
                    } else {
                        self.buttonPressed = false
                        self.robot.blacken(self.selectedEar)
                    }
                }
        }

        // MARK: Private

        @State private var buttonPressed: Bool = false
    }
}

#Preview {
    ColorPad.EarButton(selectedEar: .earRight(in: .blue), padState: .constant(.fullyPressed))
}
