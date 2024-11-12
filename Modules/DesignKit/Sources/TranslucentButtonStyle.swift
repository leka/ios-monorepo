// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct TranslucentButtonStyle: ButtonStyle {
    // MARK: Lifecycle

    public init(color: Color, isExpanded: Bool = false) {
        self.color = color
        self.isExpanded = isExpanded
    }

    // MARK: Public

    public let color: Color
    public var isExpanded: Bool

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13))
            .padding(8)
            .frame(maxWidth: self.isExpanded ? .infinity : 28)
            .frame(height: 28)
            .background(
                Capsule()
                    .fill(Color.primary.opacity(0.1))
            )
            .foregroundColor(self.color)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.3), value: self.isExpanded)
    }
}
