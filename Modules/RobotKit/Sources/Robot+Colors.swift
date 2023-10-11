// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Robot {

    public struct Color {

        public var data: [UInt8]

        public var red: UInt8 {
            data[0]
        }

        public var green: UInt8 {
            data[1]
        }

        public var blue: UInt8 {
            data[2]
        }

        // TODO(@hugo): Add all colors decided w/ Lucie, Hortense
        public static let black: Color = Color(data: [0, 0, 0])
        public static let white: Color = Color(data: [255, 255, 255])

        public static let red: Color = Color(data: [255, 0, 0])
        public static let green: Color = Color(data: [0, 255, 0])
        public static let blue: Color = Color(data: [0, 0, 255])

    }

}
