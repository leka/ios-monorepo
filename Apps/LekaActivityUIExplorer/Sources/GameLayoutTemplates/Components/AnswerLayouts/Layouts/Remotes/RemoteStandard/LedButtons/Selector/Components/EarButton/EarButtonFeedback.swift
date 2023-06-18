// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct EarButtonFeedback: View {
    var color: Color
    var backgroundDimension: Int

    var body: some View {
        Circle()
            .foregroundColor(color.opacity(0.5))
            .frame(width: CGFloat(backgroundDimension), height: CGFloat(backgroundDimension))
    }
}

struct EarButtonFeedback_Previews: PreviewProvider {
    static var previews: some View {
        EarButtonFeedback(color: .red, backgroundDimension: 60)
    }
}
