// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension Color {
    static let lkBackground: Color = .init(uiColor: .systemGray6)
}

public extension ShapeStyle where Self == Color {
    static var lkBackground: Color { .lkBackground }
}
