// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension ArrowPadView {
    struct CircleLayout: Layout {
        let xPosition: CGFloat

        func sizeThatFits(proposal: ProposedViewSize, subviews _: Subviews, cache _: inout ()) -> CGSize {
            proposal.replacingUnspecifiedDimensions()
        }

        func placeSubviews(in bounds: CGRect, proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
            let angle = Angle.degrees(360 / Double(subviews.count)).radians
            let posX = bounds.midX
            let posY = bounds.midY

            for (index, subview) in subviews.enumerated() {
                var point = CGPoint(x: self.xPosition, y: 0)
                    .applying(CGAffineTransform(rotationAngle: CGFloat(angle) * CGFloat(index - 1)))

                point.x += posX
                point.y += posY

                subview.place(at: point, anchor: .center, proposal: .unspecified)
            }
        }
    }
}
