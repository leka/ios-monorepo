// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// swiftlint:disable identifier_name large_tuple

extension UIColor {
    func toHSV() -> (hue: CGFloat, saturation: CGFloat, value: CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return (hue, saturation, brightness)
    }
}

// swiftlint:enable identifier_name large_tuple
