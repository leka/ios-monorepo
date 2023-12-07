// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension LedZoneSelectorView {
    struct EarButton: View {
        // MARK: Lifecycle

        init(selectedEar: Robot.Lights) {
            self.selectedEar = selectedEar
        }

        // MARK: Internal

        let selectedEar: Robot.Lights
        let robot = Robot.shared

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
                    self.backgroundDimension = self.buttonPressed ? 65 : 0
                }
                .background(
                    Circle()
                        .foregroundColor(self.selectedEar.color.screen.opacity(0.5))
                        .frame(width: CGFloat(self.backgroundDimension), height: CGFloat(self.backgroundDimension))
                )
                .animation(.easeInOut(duration: 0.2), value: self.backgroundDimension)
        }

        // MARK: Private

        @State private var buttonPressed = false
        @State private var backgroundDimension = 0
    }
}

#Preview {
    LedZoneSelectorView.EarButton(selectedEar: .earRight(in: .blue))
}
