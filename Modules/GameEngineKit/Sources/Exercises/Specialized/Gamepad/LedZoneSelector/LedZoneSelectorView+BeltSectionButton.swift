// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

public extension Robot.Lights {
    var arcAngle: (start: Angle, end: Angle) {
        switch self {
            case .full:
                (start: .degrees(0), end: .degrees(360))
            case .halfRight:
                (start: .degrees(10), end: .degrees(170))
            case .halfLeft:
                (start: .degrees(190), end: .degrees(350))
            case .quarterFrontRight:
                (start: .degrees(10), end: .degrees(80))
            case .quarterBackRight:
                (start: .degrees(100), end: .degrees(170))
            case .quarterBackLeft:
                (start: .degrees(190), end: .degrees(260))
            case .quarterFrontLeft:
                (start: .degrees(280), end: .degrees(350))
            default:
                (start: .degrees(0), end: .degrees(0))
        }
    }
}

// MARK: - LedZoneSelectorView.BeltSectionButton

extension LedZoneSelectorView {
    struct BeltSectionButton: View {
        // MARK: Internal

        var section: Robot.Lights
        let robot = Robot.shared

        var body: some View {
            LedZoneShape(section: self.section)
                .stroke(self.section.color.screen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .frame(width: 300, height: 300)
                .onTapGesture {
                    self.buttonPressed.toggle()
                    if self.buttonPressed {
                        self.robot.shine(self.section)
                    } else {
                        self.robot.blacken(self.section)
                    }
                    self.backgroundLineWidth = self.buttonPressed ? 25 : 0
                }
                .background(
                    LedZoneShape(section: self.section)
                        .stroke(
                            self.section.color.screen.opacity(0.3),
                            style: StrokeStyle(
                                lineWidth: CGFloat(self.backgroundLineWidth),
                                lineCap: .round,
                                lineJoin: .round,
                                miterLimit: 10
                            )
                        )
                        .frame(width: 300, height: 300)
                )
                .animation(Animation.easeInOut(duration: 0.2), value: self.backgroundLineWidth)
        }

        // MARK: Private

        @State private var buttonPressed = false
        @State private var backgroundLineWidth = 0
    }
}

#Preview {
    LedZoneSelectorView.BeltSectionButton(section: .full(.belt, in: .red))
}