// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CircleLayout: Layout {

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let angle = Angle.degrees(360 / Double(subviews.count)).radians
        let posX = bounds.midX
        let posY = bounds.midY

        for (index, subview) in subviews.enumerated() {
            var point = CGPoint(x: 180, y: 0)
                .applying(CGAffineTransform(rotationAngle: CGFloat(angle) * CGFloat(index - 1)))

            point.x += posX
            point.y += posY

            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}

struct RemoteArrowView: View {
    var body: some View {
        CircleLayout {
            TriangleButtonView(color: .yellow)
                .rotationEffect(.degrees(0))
            TriangleButtonView(color: .blue)
                .rotationEffect(.degrees(90))
            TriangleButtonView(color: .red)
                .rotationEffect(.degrees(180))
            TriangleButtonView(color: .green)
                .rotationEffect(.degrees(270))
        }
    }
}

struct RemoteArrowView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteArrowView()
    }
}
