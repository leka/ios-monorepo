// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DisplayModelFeedback: View {
    var backgroundDimension: Int

    var body: some View {
        Circle()
            .foregroundColor(LekaActivityUIExplorerAsset.Colors.btnLightBlue.swiftUIColor)
            .frame(width: CGFloat(backgroundDimension), height: CGFloat(backgroundDimension))
    }
}

struct DisplayModelFeedback_Previews: PreviewProvider {
    static var previews: some View {
        DisplayModelFeedback(backgroundDimension: 80)
    }
}
