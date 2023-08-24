// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ContinuousProgressBar: View {
    var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Capsule()
                .fill(DesignKitAsset.Colors.progressBar.swiftUIColor)
                .frame(height: 30)
                .frame(width: geometry.size.width)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(.green)
                        .frame(maxWidth: geometry.size.width * progress)
                        .padding(8)
                }
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
        .frame(maxWidth: 1100, maxHeight: 100)
    }
}
