// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

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

func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    min(max(value, lower), upper)
}

extension View {
    func onTapGestureIf(_ condition: Bool, closure: @escaping () -> Void) -> some View {
        allowsHitTesting(condition)
            .onTapGesture {
                closure()
            }
    }
}

extension Shape {
    func fill(
        _ fillStyle: some ShapeStyle, strokeBorder strokeStyle: some ShapeStyle, lineWidth: CGFloat = 1
    ) -> some View {
        stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

// rotation animations
func degreesToRadian(degrees: Double) -> Double {
    Double(degrees / 180.0 * .pi)
}
