// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public func convertJoystickPosXToPWM(posX: CGFloat, posY: CGFloat, maxValue: CGFloat) -> CGFloat {
    let leftPWM = 255.0 / maxValue * (posX - posY)

    return clamp(leftPWM, lower: -255, upper: 255)
}

public func convertJoystickPosYToPWM(posX: CGFloat, posY: CGFloat, maxValue: CGFloat) -> CGFloat {
    let rightPWM = -255 / maxValue * (posX + posY)

    return clamp(rightPWM, lower: -255, upper: 255)
}

func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}
