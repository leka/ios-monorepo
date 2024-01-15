// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension Color {
    static let lkBackground: Color = .init(uiColor: .systemGray6)
    static let lkStroke: Color = .init(uiColor: .systemGray)
}

public extension ShapeStyle where Self == Color {
    static var lkBackground: Color { .lkBackground }
    static var lkStroke: Color { .lkStroke }
}
