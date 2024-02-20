// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension Color {
    static let lkBackground: Color = .init(uiColor: .systemGray6)
    static let lkStroke: Color = .init(uiColor: .systemGray)
    static let lkNavigationTitle: Color = DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
    static let lkGreen: Color = .init(light: UIColor(displayP3Red: 175 / 255, green: 206 / 255, blue: 54 / 255, alpha: 1),
                                      dark: UIColor(displayP3Red: 175 / 255, green: 206 / 255, blue: 54 / 255, alpha: 1))
}

public extension ShapeStyle where Self == Color {
    static var lkBackground: Color { .lkBackground }
    static var lkStroke: Color { .lkStroke }
    static var lkNavigationTitle: Color { .lkNavigationTitle }
    static var lkGreen: Color { .lkGreen }
}
