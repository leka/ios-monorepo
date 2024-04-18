// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - MagicCard

// swiftlint:disable identifier_name

public struct MagicCard: Equatable {
    // MARK: Lifecycle

    public init(language: Language = .none, id: UInt16) {
        self.language = language
        self.id = id
    }

    // MARK: Public

    public enum Language: UInt8 {
        case none = 0
        case fr_FR = 1
        case en_US = 2
    }

    public let language: Language
    public let id: UInt16

    public static func == (lhs: MagicCard, rhs: MagicCard) -> Bool {
        lhs.id == rhs.id
    }

    public static func === (lhs: MagicCard, rhs: MagicCard) -> Bool {
        lhs.id == rhs.id && lhs.language == rhs.language
    }
}

public extension MagicCard {
    static let none: MagicCard = .init(id: 0x0000)
    static let emergency_stop: MagicCard = .init(id: 0x0001)
    static let dice_roll: MagicCard = .init(id: 0x0002)

    static let color_purple: MagicCard = .init(id: 0x0003)
    static let color_indigo: MagicCard = .init(id: 0x0004)
    static let color_blue: MagicCard = .init(id: 0x0005)
    static let color_green: MagicCard = .init(id: 0x0006)
    static let color_yellow: MagicCard = .init(id: 0x0007)
    static let color_orange: MagicCard = .init(id: 0x0008)
    static let color_red: MagicCard = .init(id: 0x0009)

    static let number_0: MagicCard = .init(id: 0x000A)
    static let number_1: MagicCard = .init(id: 0x000B)
    static let number_2: MagicCard = .init(id: 0x000C)
    static let number_3: MagicCard = .init(id: 0x000D)
    static let number_4: MagicCard = .init(id: 0x000E)
    static let number_5: MagicCard = .init(id: 0x000F)
    static let number_6: MagicCard = .init(id: 0x0010)
    static let number_7: MagicCard = .init(id: 0x0011)
    static let number_8: MagicCard = .init(id: 0x0012)
    static let number_9: MagicCard = .init(id: 0x0013)
    static let number_10: MagicCard = .init(id: 0x0014)

    static let shape_square: MagicCard = .init(id: 0x0015)
    static let shape_circle: MagicCard = .init(id: 0x0016)
    static let shape_triangle: MagicCard = .init(id: 0x0017)
    static let shape_star: MagicCard = .init(id: 0x0018)

    static let activity_music_quest: MagicCard = .init(id: 0x0019)
    static let activity_super_simon: MagicCard = .init(id: 0x001A)
    static let activity_colored_quest: MagicCard = .init(id: 0x001B)
    static let activity_music_colored_board: MagicCard = .init(id: 0x001C)
    static let activity_hide_and_seek: MagicCard = .init(id: 0x001D)
    static let activity_colors_and_sounds: MagicCard = .init(id: 0x001E)
    static let activity_magic_objects: MagicCard = .init(id: 0x001F)
    static let activity_dance_freeze: MagicCard = .init(id: 0x0020)

    static let gamepad_joystick_color_pad: MagicCard = .init(id: 0x0021)
    static let gamepad_arrow_pad_big: MagicCard = .init(id: 0x0022)

    static let reinforcer_1_blink_green: MagicCard = .init(id: 0x0023)
    static let reinforcer_2_spin_blink: MagicCard = .init(id: 0x0024)
    static let reinforcer_3_fire: MagicCard = .init(id: 0x0025)
    static let reinforcer_4_sprinkles: MagicCard = .init(id: 0x0026)
    static let reinforcer_5_rainbow: MagicCard = .init(id: 0x0027)

    static let emotion_fear_child: MagicCard = .init(id: 0x0028)
    static let emotion_disgust_child: MagicCard = .init(id: 0x0029)
    static let emotion_anger_child: MagicCard = .init(id: 0x002A)
    static let emotion_joy_child: MagicCard = .init(id: 0x002B)
    static let emotion_sadness_child: MagicCard = .init(id: 0x002C)
    static let emotion_fear_leka: MagicCard = .init(id: 0x002D)
    static let emotion_disgust_leka: MagicCard = .init(id: 0x002E)
    static let emotion_anger_leka: MagicCard = .init(id: 0x002F)
    static let emotion_joy_leka: MagicCard = .init(id: 0x0030)
    static let emotion_sadness_leka: MagicCard = .init(id: 0x0031)

    static let vegetable_carrot_orange: MagicCard = .init(id: 0x0032)
    static let vegetable_potato_yellow: MagicCard = .init(id: 0x0033)
    static let vegetable_salad_green: MagicCard = .init(id: 0x0034)
    static let vegetable_mushroom_grey: MagicCard = .init(id: 0x0035)
    static let fruit_strawberry_red: MagicCard = .init(id: 0x0036)
    static let fruit_cherry_pink: MagicCard = .init(id: 0x0037)
    static let fruit_apple_green: MagicCard = .init(id: 0x0038)
    static let fruit_banana_yellow: MagicCard = .init(id: 0x0039)
    static let fruit_grapes_black: MagicCard = .init(id: 0x003A)

    static let math_arithmetic_substraction_sign_minus: MagicCard = .init(id: 0x003B)
    static let math_arithmetic_addition_sign_plus: MagicCard = .init(id: 0x003C)
}

// swiftlint:enable identifier_name
