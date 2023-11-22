// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension LedZoneSelectorView {

    struct LedZoneShape: Shape {
        let section: Robot.Lights

        func path(in rect: CGRect) -> Path {
            let rotationAdjustment = Angle.degrees(90)
            let modifiedStart = section.arcAngle.start - rotationAdjustment
            let modifiedEnd = section.arcAngle.end - rotationAdjustment

            var path = Path()

            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart,
                endAngle: modifiedEnd, clockwise: false)

            return path
        }
    }

}

#Preview {
    LedZoneSelectorView.LedZoneShape(section: .quarterBackLeft(in: .red))
}
