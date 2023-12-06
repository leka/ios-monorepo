// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension LedZoneSelectorView {
    struct EarButton: View {
        let selectedEar: Robot.Lights
        let robot = Robot.shared

        @State private var buttonPressed = false
        @State private var backgroundDimension = 0

        init(selectedEar: Robot.Lights) {
            self.selectedEar = selectedEar
        }

        var body: some View {
            Circle()
                .foregroundColor(selectedEar.color.screen)
                .frame(width: 50, height: 50)
                .onTapGesture {
                    buttonPressed.toggle()
                    if buttonPressed {
                        robot.shine(selectedEar)
                    } else {
                        robot.blacken(selectedEar)
                    }
                    backgroundDimension = buttonPressed ? 65 : 0
                }
                .background(
                    Circle()
                        .foregroundColor(selectedEar.color.screen.opacity(0.5))
                        .frame(width: CGFloat(backgroundDimension), height: CGFloat(backgroundDimension))
                )
                .animation(.easeInOut(duration: 0.2), value: backgroundDimension)
        }
    }
}

#Preview {
    LedZoneSelectorView.EarButton(selectedEar: .earRight(in: .blue))
}
