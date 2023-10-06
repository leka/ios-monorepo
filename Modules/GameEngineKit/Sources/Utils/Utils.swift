// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

public func convertJoystickPosToMotorSpeed(position: CGPoint, maxValue: CGFloat) -> (
    rotationLeft: Rotation, rotationRight: Rotation
) {
    let rotationLeft: Rotation
    let rotationRight: Rotation

    let posX = position.x
    let posY = position.y

    let leftMotor = 255.0 / maxValue * (posX - posY)
    let rightMotor = -255.0 / maxValue * (posX + posY)

    let leftMotorClamped = UInt8(abs(clamp(leftMotor, lower: -255, upper: 255)))
    let rightMotorClamped = UInt8(abs(clamp(rightMotor, lower: -255, upper: 255)))

    if leftMotor > 0 {
        rotationLeft = .clockwise(speed: leftMotorClamped)
    } else if leftMotor < 0 {
        rotationLeft = .counterclockwise(speed: leftMotorClamped)
    } else {
        rotationLeft = .still
    }

    if rightMotor > 0 {
        rotationRight = .clockwise(speed: rightMotorClamped)
    } else if rightMotor < 0 {
        rotationRight = .counterclockwise(speed: rightMotorClamped)
    } else {
        rotationRight = .still
    }

    return (rotationLeft, rotationRight)
}

func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    min(max(value, lower), upper)
}

extension View {
    func onTapGestureIf(_ condition: Bool, closure: @escaping () -> Void) -> some View {
        self.allowsHitTesting(condition)
            .onTapGesture {
                closure()
            }
    }
}

extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1
    ) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

// rotation animations
func degreesToRadian(degrees: Double) -> Double {
    Double(degrees / 180.0 * .pi)
}
