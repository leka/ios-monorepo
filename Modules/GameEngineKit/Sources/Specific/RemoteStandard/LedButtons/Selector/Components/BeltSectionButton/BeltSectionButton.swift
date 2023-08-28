// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum BeltSection {
    case full
    case right, left
    case frontRight, backRight, backLeft, frontLeft

    func angles() -> (startAngle: Angle, endAngle: Angle) {
        switch self {
            case .full:
                return (startAngle: .degrees(0), endAngle: .degrees(360))
            case .right:
                return (startAngle: .degrees(10), endAngle: .degrees(170))
            case .left:
                return (startAngle: .degrees(190), endAngle: .degrees(350))
            case .frontRight:
                return (startAngle: .degrees(10), endAngle: .degrees(80))
            case .backRight:
                return (startAngle: .degrees(100), endAngle: .degrees(170))
            case .backLeft:
                return (startAngle: .degrees(190), endAngle: .degrees(260))
            case .frontLeft:
                return (startAngle: .degrees(280), endAngle: .degrees(350))
        }
    }

    func ledRange() -> (start: UInt8, end: UInt8) {
        switch self {
            case .full:
                return (start: 0, end: 19)
            case .right:
                return (start: 10, end: 19)
            case .left:
                return (start: 0, end: 9)
            case .frontRight:
                return (start: 15, end: 19)
            case .backRight:
                return (start: 10, end: 14)
            case .backLeft:
                return (start: 5, end: 9)
            case .frontLeft:
                return (start: 0, end: 4)
        }
    }
}

struct BeltSectionButton: View {
    var section: BeltSection
    var color: Color

    @State private var buttonPressed = false
    @State private var backgroundLineWidth = 0

    var body: some View {
        ArcShape(section: section)
            .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
            .frame(width: 300, height: 300)
            .onTapGesture {
                buttonPressed.toggle()
                if buttonPressed {
                    // TODO(@ladislas): Turn on lights from "section.ledRange().start" to "section.ledRange().end" in "color"
                    print("Leds \(section.ledRange().start) to \(section.ledRange().end) are in \(color)")
                } else {
                    // TODO(@ladislas): Turn off lights from "section.ledRange().start" to "section.ledRange().end"
                    print("Leds \(section.ledRange().start) to \(section.ledRange().end) are in off")
                }
                backgroundLineWidth = buttonPressed ? 25 : 0
            }
            .background(
                BeltSectionButtonFeedback(section: section, color: color, lineWidth: backgroundLineWidth)
            )
            .animation(.easeInOut(duration: 0.2), value: backgroundLineWidth)
    }
}

struct BeltSectionButton_Previews: PreviewProvider {
    static var previews: some View {
        BeltSectionButton(section: .backLeft, color: .red)
    }
}
