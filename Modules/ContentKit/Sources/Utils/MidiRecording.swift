// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct MidiRecording: Codable, Hashable, Equatable {
    // MARK: Lifecycle

    public init(name: String, file: String, scale: [UInt8]) {
        self.name = name
        self.file = file
        self.scale = scale
    }

    public init(_ song: Song) {
        self.name = song.details.name
        self.file = song.details.file
        self.scale = song.scale
    }

    // MARK: Public

    public enum Song: String, Codable {
        case none
        case underTheMoonlight
        case aGreenMouse
        case twinkleTwinkleLittleStar
        case londonBridgeIsFallingDown
        case ohTheCrocodiles
        case happyBirthday

        // MARK: Internal

        var details: (name: String, file: String) {
            switch self {
                case .none:
                    (name: "", file: "")
                case .underTheMoonlight:
                    (
                        name: "Under The Moonlight", file: "Under_The_Moonlight"
                    )
                case .aGreenMouse:
                    (name: "A Green Mouse", file: "A_Green_Mouse")
                case .twinkleTwinkleLittleStar:
                    (
                        name: "Twinkle Twinkle Little Star", file: "Twinkle_Twinkle_Little_Star"
                    )
                case .londonBridgeIsFallingDown:
                    (
                        name: "London Bridge Is Falling Down", file: "London_Bridge_Is_Falling_Down"
                    )
                case .ohTheCrocodiles:
                    (
                        name: "Oh The Crocodiles", file: "Oh_The_Crocodiles"
                    )
                case .happyBirthday:
                    (name: "Happy Birthday", file: "Happy_Birthday")
            }
        }

        var scale: [UInt8] {
            switch self {
                case .none:
                    []
                case .underTheMoonlight:
                    [24, 26, 28, 29, 31, 33, 35, 36]
                case .aGreenMouse:
                    [24, 26, 28, 29, 31, 33, 34, 36]
                case .twinkleTwinkleLittleStar:
                    [24, 26, 28, 29, 31, 33, 35, 36]
                case .londonBridgeIsFallingDown:
                    [24, 26, 28, 29, 31, 33, 35, 36]
                case .ohTheCrocodiles:
                    [24, 28, 29, 31, 33, 34, 35, 36]
                case .happyBirthday:
                    [24, 26, 28, 29, 31, 33, 34, 36]
            }
        }
    }

    public let name: String
    public let file: String
    public let scale: [UInt8]
}
