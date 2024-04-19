// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - Robot.Color

// swiftlint:disable nesting

public extension Robot {
    struct Color {
        // MARK: Lifecycle

        public init(robot rRGB: UInt8..., screen sRGB: UInt8...) {
            guard rRGB.count == 3, sRGB.count == 3 else { fatalError() }

            self.robotRGB = rRGB
            self.screenRGB = sRGB
        }

        public init(from value: String) {
            guard let color = ColorString(rawValue: value)?.color else {
                fatalError("Invalid color string \(value)")
            }
            self = color
        }

        public init(red: UInt8, green: UInt8, blue: UInt8) {
            self.robotRGB = [red, green, blue]
            self.screenRGB = [red, green, blue]
        }

        // MARK: Public

        public var robot: [UInt8] {
            self.robotRGB
        }

        public var screen: SwiftUI.Color {
            SwiftUI.Color(
                red: Double(self.screenRGB[0]) / 255.0,
                green: Double(self.screenRGB[1]) / 255.0,
                blue: Double(self.screenRGB[2]) / 255.0
            )
        }

        public var robotUiColor: UIColor {
            UIColor(
                red: Double(self.robotRGB[0]) / 255.0,
                green: Double(self.robotRGB[1]) / 255.0,
                blue: Double(self.robotRGB[2]) / 255.0,
                alpha: 1.0
            )
        }

        public var screenUiColor: UIColor {
            UIColor(
                red: Double(self.screenRGB[0]) / 255.0,
                green: Double(self.screenRGB[1]) / 255.0,
                blue: Double(self.screenRGB[2]) / 255.0,
                alpha: 1.0
            )
        }

        // MARK: Private

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

            // MARK: Public

            public var color: Robot.Color {
                switch self {
                    case .black:
                        .black
                    case .white:
                        .white
                    case .red:
                        .red
                    case .green:
                        .green
                    case .blue:
                        .blue
                    case .lightBlue:
                        .lightBlue
                    case .orange:
                        .orange
                    case .purple:
                        .purple
                    case .pink:
                        .pink
                    case .yellow:
                        .yellow
                }
            }
        }

        private let robotRGB: [UInt8]
        private let screenRGB: [UInt8]
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
