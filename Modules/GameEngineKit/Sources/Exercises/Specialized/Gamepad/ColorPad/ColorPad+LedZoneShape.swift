// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension ColorPad {
    struct LedZoneShape: Shape {
        let section: Robot.Lights

        func path(in rect: CGRect) -> Path {
            let rotationAdjustment = Angle.degrees(90)
            let modifiedStart = self.section.arcAngle.start - rotationAdjustment
            let modifiedEnd = self.section.arcAngle.end - rotationAdjustment

            var path = Path()

            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart,
                endAngle: modifiedEnd, clockwise: false
            )

            return path
        }
    }
}

#Preview {
    ColorPad.LedZoneShape(section: .quarterBackLeft(in: .red))
}
