// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

public func convertJoystickPosToSpeedDeprecated(position: CGPoint, maxValue: CGFloat) -> (
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

func clampDeprecated<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    min(max(value, lower), upper)
}

extension View {
    func onTapGestureIfDeprecated(_ condition: Bool, closure: @escaping () -> Void) -> some View {
        self.allowsHitTesting(condition)
            .onTapGesture {
                closure()
            }
    }
}

extension Shape {
    func fillDeprecated<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1
    ) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

// rotation animations
func degreesToRadianDeprecated(degrees: Double) -> Double {
    Double(degrees / 180.0 * .pi)
}
