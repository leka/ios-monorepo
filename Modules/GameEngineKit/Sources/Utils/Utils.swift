// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UtilsKit

public func convertJoystickPosToSpeed(position: CGPoint, maxValue: CGFloat) -> (
    leftSpeed: CGFloat, leftRight: CGFloat
) {
    let posX = position.x
    let posY = position.y

    let leftSpeed = (posX - posY) / maxValue
    let rightSpeed = -(posX + posY) / maxValue

    let leftSpeedClamped = clamp(leftSpeed, lower: -1.0, upper: 1.0)
    let rightSpeedClamped = clamp(rightSpeed, lower: -1.0, upper: 1.0)

    return (leftSpeedClamped, rightSpeedClamped)
}
