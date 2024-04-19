// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - Robot.Color

// swiftlint:disable identifier_name

public extension Robot {
    struct Gradient {
        // MARK: Lifecycle

        public init(fromColors colors: Color...) {
            self.gradientColors = colors
        }

        // MARK: Public

        public func color(at position: Float) -> Robot.Color {
            let positionClamped = max(min(position, 1), 0)

            let scaledIndex = positionClamped * Float(self.gradientColors.count - 1)
            let firstIndex = Int(scaledIndex)
            let secondIndex = min(firstIndex + 1, gradientColors.count - 1)
            let fraction = CGFloat(scaledIndex - Float(firstIndex))

            let firstColor = self.gradientColors[firstIndex]
            let secondColor = self.gradientColors[secondIndex]

            let (h1, s1, v1) = firstColor.robotUiColor.toHSV()
            let (h2, s2, v2) = secondColor.robotUiColor.toHSV()

            let h = self.interpolateHue(from: h1, to: h2, fraction: fraction)
            let s = self.interpolate(from: s1, to: s2, fraction: fraction)
            let v = self.interpolate(from: v1, to: v2, fraction: fraction)

            let uiColor = UIColor(hue: h, saturation: s, brightness: v, alpha: 1)

            let r = UInt8(max(min(uiColor.cgColor.components![0] * 255.0, 255), 0))
            let g = UInt8(max(min(uiColor.cgColor.components![1] * 255.0, 255), 0))
            let b = UInt8(max(min(uiColor.cgColor.components![2] * 255.0, 255), 0))

            return Robot.Color(red: r, green: g, blue: b)
        }

        // MARK: Private

        private let gradientColors: [Robot.Color]

        private func interpolate(from start: CGFloat, to end: CGFloat, fraction: CGFloat) -> CGFloat {
            start + (end - start) * fraction
        }

        private func interpolateHue(from start: CGFloat, to end: CGFloat, fraction: CGFloat) -> CGFloat {
            let diff = abs(end - start)
            if diff > 0.5 {
                if start > end {
                    return (start + ((1.0 + end - start) * fraction)).truncatingRemainder(dividingBy: 1.0)
                } else {
                    return (start - ((1.0 + start - end) * fraction)).truncatingRemainder(dividingBy: 1.0)
                }
            } else {
                return self.interpolate(from: start, to: end, fraction: fraction)
            }
        }
    }
}

// swiftlint:enable identifier_name
