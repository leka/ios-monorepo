// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - AnimatableBlur

struct AnimatableBlur: AnimatableModifier {
    var blurRadius: CGFloat

    var animatableData: CGFloat {
        get { self.blurRadius }
        set { self.blurRadius = newValue }
    }

    func body(content: Content) -> some View {
        content
            .blur(radius: self.blurRadius)
    }
}

// MARK: - AnimatableSaturation

struct AnimatableSaturation: AnimatableModifier {
    var saturation: Double

    var animatableData: Double {
        get { self.saturation }
        set { self.saturation = newValue }
    }

    func body(content: Content) -> some View {
        content
            .saturation(self.saturation)
    }
}
