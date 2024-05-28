// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension Shape {
    func fill(
        _ fillStyle: some ShapeStyle, strokeBorder strokeStyle: some ShapeStyle, lineWidth: CGFloat = 1
    ) -> some View {
        stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}
