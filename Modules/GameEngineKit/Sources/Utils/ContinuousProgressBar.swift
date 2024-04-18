// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ContinuousProgressBar: View {
    let kHeight: CGFloat = 30
    var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Capsule()
                .fill(DesignKitAsset.Colors.progressBar.swiftUIColor)
                .frame(height: self.kHeight)
                .frame(width: geometry.size.width)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(.green)
                        .frame(maxWidth: geometry.size.width * self.progress)
                        .padding(8)
                }
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
        .frame(maxHeight: self.kHeight)
    }
}

#Preview {
    ContinuousProgressBar(progress: 0.5)
}
