// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ArcShape: Shape {
    let section: BeltSection

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = section.angles().startAngle - rotationAdjustment
        let modifiedEnd = section.angles().endAngle - rotationAdjustment

        var path = Path()

        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart,
            endAngle: modifiedEnd, clockwise: false)

        return path
    }
}
