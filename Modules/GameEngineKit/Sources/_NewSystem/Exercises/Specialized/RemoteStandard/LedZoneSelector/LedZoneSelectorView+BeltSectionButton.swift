// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension Robot.Lights {
    public var arcAngle: (start: Angle, end: Angle) {
        switch self {
            case .full:
                return (start: .degrees(0), end: .degrees(360))
            case .halfRight:
                return (start: .degrees(10), end: .degrees(170))
            case .halfLeft:
                return (start: .degrees(190), end: .degrees(350))
            case .quarterFrontRight:
                return (start: .degrees(10), end: .degrees(80))
            case .quarterBackRight:
                return (start: .degrees(100), end: .degrees(170))
            case .quarterBackLeft:
                return (start: .degrees(190), end: .degrees(260))
            case .quarterFrontLeft:
                return (start: .degrees(280), end: .degrees(350))
            default:
                return (start: .degrees(0), end: .degrees(0))
        }
    }
}

extension LedZoneSelectorView {
    struct BeltSectionButton: View {
        var section: Robot.Lights
        let robot = Robot.shared

        @State private var buttonPressed = false
        @State private var backgroundLineWidth = 0

        var body: some View {
            LedZoneShape(section: section)
                .stroke(section.color.screen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .frame(width: 300, height: 300)
                .onTapGesture {
                    buttonPressed.toggle()
                    if buttonPressed {
                        robot.shine(section)
                    } else {
                        robot.blacken(section)
                    }
                    backgroundLineWidth = buttonPressed ? 25 : 0
                }
                .background(
                    LedZoneShape(section: section)
                        .stroke(
                            section.color.screen.opacity(0.3),
                            style: StrokeStyle(
                                lineWidth: CGFloat(backgroundLineWidth),
                                lineCap: .round,
                                lineJoin: .round,
                                miterLimit: 10)
                        )
                        .frame(width: 300, height: 300)
                )
                .animation(Animation.easeInOut(duration: 0.2), value: backgroundLineWidth)
        }
    }
}

#Preview {
    LedZoneSelectorView.BeltSectionButton(section: .full(.belt, in: .red))
}
