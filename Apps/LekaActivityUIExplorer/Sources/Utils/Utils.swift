// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public func convertJoystickPosToMotorSpeed(position: CGPoint, maxValue: CGFloat) -> (
    leftMotor: Float, rightMotor: Float
) {
    let posX = position.x
    let posY = position.y

    let leftMotor = 255.0 / maxValue * (posX - posY)
    let rightMotor = -255.0 / maxValue * (posX + posY)

    let leftMotorClamped = Float(clamp(leftMotor, lower: -255, upper: 255))
    let rightMotorClamped = Float(clamp(rightMotor, lower: -255, upper: 255))

    return (leftMotorClamped, rightMotorClamped)
}

func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}
