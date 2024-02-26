// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct RightAnswerFeedback: View {
    public var animationPercent: CGFloat

    public var body: some View {
        Circle()
            .trim(from: 0, to: self.animationPercent)
            .stroke(
                .green,
                style: StrokeStyle(
                    lineWidth: 6,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 10
                )
            )
    }
}
