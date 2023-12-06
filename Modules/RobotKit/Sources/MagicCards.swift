// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swiftlint:disable identifier_name

public struct MagicCard: Equatable {
    public enum Language: UInt8 {
        case none = 0
        case fr_FR = 1
        case en_US = 2
    }

    public let language: Language
    public let id: UInt16

    public init(language: Language = .none, id: UInt16) {
        self.language = language
        self.id = id
    }

    public static func == (lhs: MagicCard, rhs: MagicCard) -> Bool {
        lhs.id == rhs.id
    }

    public static func === (lhs: MagicCard, rhs: MagicCard) -> Bool {
        lhs.id == rhs.id && lhs.language == rhs.language
    }
}

public extension MagicCard {
    static let none: MagicCard = MagicCard(id: 0x00_00)
    static let emergency_stop: MagicCard = MagicCard(id: 0x00_01)
    static let dice_roll: MagicCard = MagicCard(id: 0x00_02)

    static let color_purple: MagicCard = MagicCard(id: 0x00_03)
    static let color_indigo: MagicCard = MagicCard(id: 0x00_04)
    static let color_blue: MagicCard = MagicCard(id: 0x00_05)
    static let color_green: MagicCard = MagicCard(id: 0x00_06)
    static let color_yellow: MagicCard = MagicCard(id: 0x00_07)
    static let color_orange: MagicCard = MagicCard(id: 0x00_08)
    static let color_red: MagicCard = MagicCard(id: 0x00_09)

    static let number_0: MagicCard = MagicCard(id: 0x00_0A)
    static let number_1: MagicCard = MagicCard(id: 0x00_0B)
    static let number_2: MagicCard = MagicCard(id: 0x00_0C)
    static let number_3: MagicCard = MagicCard(id: 0x00_0D)
    static let number_4: MagicCard = MagicCard(id: 0x00_0E)
    static let number_5: MagicCard = MagicCard(id: 0x00_0F)
    static let number_6: MagicCard = MagicCard(id: 0x00_10)
    static let number_7: MagicCard = MagicCard(id: 0x00_11)
    static let number_8: MagicCard = MagicCard(id: 0x00_12)
    static let number_9: MagicCard = MagicCard(id: 0x00_13)
    static let number_10: MagicCard = MagicCard(id: 0x00_14)

    static let shape_square: MagicCard = MagicCard(id: 0x00_15)
    static let shape_circle: MagicCard = MagicCard(id: 0x00_16)
    static let shape_triangle: MagicCard = MagicCard(id: 0x00_17)
    static let shape_star: MagicCard = MagicCard(id: 0x00_18)

    static let activity_music_quest: MagicCard = MagicCard(id: 0x00_19)
    static let activity_super_simon: MagicCard = MagicCard(id: 0x00_1A)
    static let activity_colored_quest: MagicCard = MagicCard(id: 0x00_1B)
    static let activity_music_colored_board: MagicCard = MagicCard(id: 0x00_1C)
    static let activity_hide_and_seek: MagicCard = MagicCard(id: 0x00_1D)
    static let activity_colors_and_sounds: MagicCard = MagicCard(id: 0x00_1E)
    static let activity_magic_objects: MagicCard = MagicCard(id: 0x00_1F)
    static let activity_dance_freeze: MagicCard = MagicCard(id: 0x00_20)

    static let remote_standard: MagicCard = MagicCard(id: 0x00_21)
    static let remote_colored_arrows: MagicCard = MagicCard(id: 0x00_22)

    static let reinforcer_1_blink_green: MagicCard = MagicCard(id: 0x00_23)
    static let reinforcer_2_spin_blink: MagicCard = MagicCard(id: 0x00_24)
    static let reinforcer_3_fire: MagicCard = MagicCard(id: 0x00_25)
    static let reinforcer_4_sprinkles: MagicCard = MagicCard(id: 0x00_26)
    static let reinforcer_5_rainbow: MagicCard = MagicCard(id: 0x00_27)

    static let emotion_fear_child: MagicCard = MagicCard(id: 0x00_28)
    static let emotion_disgust_child: MagicCard = MagicCard(id: 0x00_29)
    static let emotion_anger_child: MagicCard = MagicCard(id: 0x00_2A)
    static let emotion_joy_child: MagicCard = MagicCard(id: 0x00_2B)
    static let emotion_sadness_child: MagicCard = MagicCard(id: 0x00_2C)
    static let emotion_fear_leka: MagicCard = MagicCard(id: 0x00_2D)
    static let emotion_disgust_leka: MagicCard = MagicCard(id: 0x00_2E)
    static let emotion_anger_leka: MagicCard = MagicCard(id: 0x00_2F)
    static let emotion_joy_leka: MagicCard = MagicCard(id: 0x00_30)
    static let emotion_sadness_leka: MagicCard = MagicCard(id: 0x00_31)

    static let vegetable_carrot_orange: MagicCard = MagicCard(id: 0x00_32)
    static let vegetable_potato_yellow: MagicCard = MagicCard(id: 0x00_33)
    static let vegetable_salad_green: MagicCard = MagicCard(id: 0x00_34)
    static let vegetable_mushroom_grey: MagicCard = MagicCard(id: 0x00_35)
    static let fruit_strawberry_red: MagicCard = MagicCard(id: 0x00_36)
    static let fruit_cherry_pink: MagicCard = MagicCard(id: 0x00_37)
    static let fruit_apple_green: MagicCard = MagicCard(id: 0x00_38)
    static let fruit_banana_yellow: MagicCard = MagicCard(id: 0x00_39)
    static let fruit_grapes_black: MagicCard = MagicCard(id: 0x00_3A)

    static let math_arithmetic_substraction_sign_minus: MagicCard = MagicCard(id: 0x00_3B)
    static let math_arithmetic_addition_sign_plus: MagicCard = MagicCard(id: 0x00_3C)
}

// swiftlint:enable identifier_name
