// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct BeltSectionButtonFeedback: View {
    var section: BeltSection
    var color: Color
    var lineWidth: Int

    var body: some View {
        ArcShape(section: section)
            .stroke(
                color.opacity(0.5),
                style: StrokeStyle(
                    lineWidth: CGFloat(lineWidth),
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 10)
            )
            .frame(width: 300, height: 300)
    }
}

struct BeltSectionButtonFeedback_Previews: PreviewProvider {
    static var previews: some View {
        BeltSectionButtonFeedback(section: .frontRight, color: .red, lineWidth: 20)
    }
}
