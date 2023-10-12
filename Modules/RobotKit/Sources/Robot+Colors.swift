// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension Robot {

    public struct Color {

        private let robotRGB: [UInt8]
        private let screenRGB: [UInt8]

        public init(robot rRGB: UInt8..., screen sRGB: UInt8...) {
            guard rRGB.count == 3 && sRGB.count == 3 else { fatalError() }

            self.robotRGB = rRGB
            self.screenRGB = sRGB
        }

        public var robot: [UInt8] {
            robotRGB
        }

        public var screen: SwiftUI.Color {
            SwiftUI.Color(
                red: Double(screenRGB[0]) / 255.0,
                green: Double(screenRGB[1]) / 255.0,
                blue: Double(screenRGB[2]) / 255.0
            )
        }

        public static let black: Color = Color(robot: 0, 0, 0, screen: 0, 0, 0)
        public static let white: Color = Color(robot: 255, 255, 255, screen: 255, 255, 255)

        public static let red: Color = Color(robot: 255, 0, 0, screen: 255, 0, 0)
        public static let green: Color = Color(robot: 0, 150, 0, screen: 0, 226, 0)
        public static let blue: Color = Color(robot: 0, 0, 255, screen: 0, 121, 255)

        public static let lightBlue: Color = Color(robot: 0, 121, 255, screen: 70, 194, 248)
        public static let orange: Color = Color(robot: 248, 100, 0, screen: 255, 143, 0)
        public static let purple: Color = Color(robot: 20, 0, 80, screen: 173, 73, 247)
        public static let pink: Color = Color(robot: 255, 0, 127, screen: 252, 103, 178)
        public static let yellow: Color = Color(robot: 255, 255, 0, screen: 251, 232, 0)

    }

}
