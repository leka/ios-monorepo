// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI
import SwiftUIJoystick

struct JoystickView: View {

    @StateObject public var joystickMonitor = JoystickMonitor()
    @State private var leftMotor: UInt8 = 0
    @State private var rightMotor: UInt8 = 0

    private let power = 255.0 / 300.0

    private let dragDiameter: CGFloat = 300
    private let shape: JoystickShape = .circle

    public var body: some View {
        VStack {
            JoystickBuilder(
                monitor: self.joystickMonitor,
                width: self.dragDiameter,
                shape: self.shape,

                background: {
                    ZStack {
                        Circle()
                            .fill(.white)
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.gray)

                        VStack(spacing: 110) {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.gray.opacity(0.7))

                            HStack(spacing: 250) {
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(.gray.opacity(0.7))

                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.gray.opacity(0.7))
                            }

                            Image(systemName: "arrow.down")
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    }
                },
                foreground: {
                    Circle()
                        .fill(.gray)
                },
                locksInPlace: false)

//            Text("XY Point = (x: \(joystickMonitor.xyPoint.x), y: \(joystickMonitor.xyPoint.y))")
//                .fixedSize()
//            Text("Motor PWM = (left: \(convertPosXToPWM()), right: \(convertPosYToPWM()))")
//                .fixedSize()
        }

    }

    func convertPosXToPWM() -> CGFloat {
        let leftPWM = 255.0 / dragDiameter * (joystickMonitor.xyPoint.x - joystickMonitor.xyPoint.y)

        return clamp(leftPWM, lower: -255, upper: 255)
    }

    func convertPosYToPWM() -> CGFloat {
        let rightPWM = -255 / dragDiameter * (joystickMonitor.xyPoint.x + joystickMonitor.xyPoint.y)

        return clamp(rightPWM, lower: -255, upper: 255)
    }

    fileprivate func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }

}
