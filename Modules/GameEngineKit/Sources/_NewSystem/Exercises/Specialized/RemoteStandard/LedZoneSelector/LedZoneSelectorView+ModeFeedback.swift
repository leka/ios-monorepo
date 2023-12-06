// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension LedZoneSelectorView {

    struct ModeFeedback: View {
        var backgroundDimension: Int

        var body: some View {
            Circle()
                .foregroundColor(DesignKitAsset.Colors.btnLightBlue.swiftUIColor)
                .frame(width: CGFloat(backgroundDimension), height: CGFloat(backgroundDimension))
        }
    }
}

#Preview {
    LedZoneSelectorView.ModeFeedback(backgroundDimension: 80)
}
