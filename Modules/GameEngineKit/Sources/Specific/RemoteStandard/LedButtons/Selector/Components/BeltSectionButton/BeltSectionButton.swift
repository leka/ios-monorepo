// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum BeltSection {
    case full
    case right, left
    case frontRight, backRight, backLeft, frontLeft

    public var arcAngle: (start: Angle, end: Angle) {
        switch self {
            case .full:
                return (start: .degrees(0), end: .degrees(360))
            case .right:
                return (start: .degrees(10), end: .degrees(170))
            case .left:
                return (start: .degrees(190), end: .degrees(350))
            case .frontRight:
                return (start: .degrees(10), end: .degrees(80))
            case .backRight:
                return (start: .degrees(100), end: .degrees(170))
            case .backLeft:
                return (start: .degrees(190), end: .degrees(260))
            case .frontLeft:
                return (start: .degrees(280), end: .degrees(350))
        }
    }

    public var ledRange: (first: UInt8, last: UInt8) {
        switch self {
            case .full:
                return (first: 0, last: 19)
            case .right:
                return (first: 10, last: 19)
            case .left:
                return (first: 0, last: 9)
            case .frontRight:
                return (first: 15, last: 19)
            case .backRight:
                return (first: 10, last: 14)
            case .backLeft:
                return (first: 5, last: 9)
            case .frontLeft:
                return (first: 0, last: 4)
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
                    // TODO(@ladislas): Turn on lights from "section.ledRange.start" to "section.ledRange.last" in "color"
                    print("Leds \(section.ledRange.first) to \(section.ledRange.last) are in \(color)")
                } else {
                    // TODO(@ladislas): Turn off lights from "section.ledRange.first" to "section.ledRange.last"
                    print("Leds \(section.ledRange.first) to \(section.ledRange.last) are in off")
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
