// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Robot {

    public struct Color {

        public var data: [UInt8]

        init(_ values: UInt8...) {
            guard values.count == 3 else { fatalError() }
            data = values
        }

        public var red: UInt8 {
            data[0]
        }

        public var green: UInt8 {
            data[1]
        }

        public var blue: UInt8 {
            data[2]
        }

        public static let black: Color = Color(0, 0, 0)
        public static let white: Color = Color(255, 255, 255)

        public static let red: Color = Color(255, 0, 0)
        public static let green: Color = Color(0, 150, 0)
        public static let blue: Color = Color(0, 0, 255)

        public static let orange: Color = Color(248, 100, 0)
        public static let yellow: Color = Color(255, 255, 0)
        public static let lightBlue: Color = Color(0, 121, 255)
        public static let purple: Color = Color(20, 0, 80)
        public static let pink: Color = Color(255, 0, 127)

    }

}
