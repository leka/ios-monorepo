// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - Robot.Color

// swiftlint:disable nesting

public extension Robot {
    struct Color {
        private let robotRGB: [UInt8]
        private let screenRGB: [UInt8]

        public init(robot rRGB: UInt8..., screen sRGB: UInt8...) {
            guard rRGB.count == 3, sRGB.count == 3 else { fatalError() }

            self.robotRGB = rRGB
            self.screenRGB = sRGB
        }

        private enum ColorString: String {
            case black
            case white
            case red
            case green
            case blue
            case lightBlue
            case orange
            case purple
            case pink
            case yellow

            public var color: Robot.Color {
                switch self {
                    case .black:
                        return .black
                    case .white:
                        return .white
                    case .red:
                        return .red
                    case .green:
                        return .green
                    case .blue:
                        return .blue
                    case .lightBlue:
                        return .lightBlue
                    case .orange:
                        return .orange
                    case .purple:
                        return .purple
                    case .pink:
                        return .pink
                    case .yellow:
                        return .yellow
                }
            }
        }

        public init(from value: String) {
            guard let color = ColorString(rawValue: value)?.color else {
                fatalError("Invalid color string \(value)")
            }
            self = color
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
    }
}

public extension Robot.Color {
    static let black: Robot.Color = .init(robot: 0, 0, 0, screen: 0, 0, 0)
    static let white: Robot.Color = .init(robot: 255, 255, 255, screen: 255, 255, 255)

    static let red: Robot.Color = .init(robot: 255, 0, 0, screen: 255, 0, 0)
    static let green: Robot.Color = .init(robot: 0, 150, 0, screen: 0, 226, 0)
    static let blue: Robot.Color = .init(robot: 0, 0, 255, screen: 0, 121, 255)

    static let lightBlue: Robot.Color = .init(robot: 0, 121, 255, screen: 70, 194, 248)
    static let orange: Robot.Color = .init(robot: 248, 100, 0, screen: 255, 143, 0)
    static let purple: Robot.Color = .init(robot: 20, 0, 80, screen: 173, 73, 247)
    static let pink: Robot.Color = .init(robot: 255, 0, 127, screen: 252, 103, 178)
    static let yellow: Robot.Color = .init(robot: 255, 255, 0, screen: 251, 232, 0)
}

// swiftlint:enable nesting
