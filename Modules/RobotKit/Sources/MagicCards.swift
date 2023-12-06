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

extension MagicCard {

    public static let none: MagicCard = MagicCard(id: 0x00_00)
    public static let emergency_stop: MagicCard = MagicCard(id: 0x00_01)
    public static let dice_roll: MagicCard = MagicCard(id: 0x00_02)

    public static let color_purple: MagicCard = MagicCard(id: 0x00_03)
    public static let color_indigo: MagicCard = MagicCard(id: 0x00_04)
    public static let color_blue: MagicCard = MagicCard(id: 0x00_05)
    public static let color_green: MagicCard = MagicCard(id: 0x00_06)
    public static let color_yellow: MagicCard = MagicCard(id: 0x00_07)
    public static let color_orange: MagicCard = MagicCard(id: 0x00_08)
    public static let color_red: MagicCard = MagicCard(id: 0x00_09)

    public static let number_0: MagicCard = MagicCard(id: 0x00_0A)
    public static let number_1: MagicCard = MagicCard(id: 0x00_0B)
    public static let number_2: MagicCard = MagicCard(id: 0x00_0C)
    public static let number_3: MagicCard = MagicCard(id: 0x00_0D)
    public static let number_4: MagicCard = MagicCard(id: 0x00_0E)
    public static let number_5: MagicCard = MagicCard(id: 0x00_0F)
    public static let number_6: MagicCard = MagicCard(id: 0x00_10)
    public static let number_7: MagicCard = MagicCard(id: 0x00_11)
    public static let number_8: MagicCard = MagicCard(id: 0x00_12)
    public static let number_9: MagicCard = MagicCard(id: 0x00_13)
    public static let number_10: MagicCard = MagicCard(id: 0x00_14)

    public static let shape_square: MagicCard = MagicCard(id: 0x00_15)
    public static let shape_circle: MagicCard = MagicCard(id: 0x00_16)
    public static let shape_triangle: MagicCard = MagicCard(id: 0x00_17)
    public static let shape_star: MagicCard = MagicCard(id: 0x00_18)

    public static let activity_music_quest: MagicCard = MagicCard(id: 0x00_19)
    public static let activity_super_simon: MagicCard = MagicCard(id: 0x00_1A)
    public static let activity_colored_quest: MagicCard = MagicCard(id: 0x00_1B)
    public static let activity_music_colored_board: MagicCard = MagicCard(id: 0x00_1C)
    public static let activity_hide_and_seek: MagicCard = MagicCard(id: 0x00_1D)
    public static let activity_colors_and_sounds: MagicCard = MagicCard(id: 0x00_1E)
    public static let activity_magic_objects: MagicCard = MagicCard(id: 0x00_1F)
    public static let activity_dance_freeze: MagicCard = MagicCard(id: 0x00_20)

    public static let remote_standard: MagicCard = MagicCard(id: 0x00_21)
    public static let remote_colored_arrows: MagicCard = MagicCard(id: 0x00_22)

    public static let reinforcer_1_blink_green: MagicCard = MagicCard(id: 0x00_23)
    public static let reinforcer_2_spin_blink: MagicCard = MagicCard(id: 0x00_24)
    public static let reinforcer_3_fire: MagicCard = MagicCard(id: 0x00_25)
    public static let reinforcer_4_sprinkles: MagicCard = MagicCard(id: 0x00_26)
    public static let reinforcer_5_rainbow: MagicCard = MagicCard(id: 0x00_27)

    public static let emotion_fear_child: MagicCard = MagicCard(id: 0x00_28)
    public static let emotion_disgust_child: MagicCard = MagicCard(id: 0x00_29)
    public static let emotion_anger_child: MagicCard = MagicCard(id: 0x00_2A)
    public static let emotion_joy_child: MagicCard = MagicCard(id: 0x00_2B)
    public static let emotion_sadness_child: MagicCard = MagicCard(id: 0x00_2C)
    public static let emotion_fear_leka: MagicCard = MagicCard(id: 0x00_2D)
    public static let emotion_disgust_leka: MagicCard = MagicCard(id: 0x00_2E)
    public static let emotion_anger_leka: MagicCard = MagicCard(id: 0x00_2F)
    public static let emotion_joy_leka: MagicCard = MagicCard(id: 0x00_30)
    public static let emotion_sadness_leka: MagicCard = MagicCard(id: 0x00_31)

    public static let vegetable_carrot_orange: MagicCard = MagicCard(id: 0x00_32)
    public static let vegetable_potato_yellow: MagicCard = MagicCard(id: 0x00_33)
    public static let vegetable_salad_green: MagicCard = MagicCard(id: 0x00_34)
    public static let vegetable_mushroom_grey: MagicCard = MagicCard(id: 0x00_35)
    public static let fruit_strawberry_red: MagicCard = MagicCard(id: 0x00_36)
    public static let fruit_cherry_pink: MagicCard = MagicCard(id: 0x00_37)
    public static let fruit_apple_green: MagicCard = MagicCard(id: 0x00_38)
    public static let fruit_banana_yellow: MagicCard = MagicCard(id: 0x00_39)
    public static let fruit_grapes_black: MagicCard = MagicCard(id: 0x00_3A)

    public static let math_arithmetic_substraction_sign_minus: MagicCard = MagicCard(id: 0x00_3B)
    public static let math_arithmetic_addition_sign_plus: MagicCard = MagicCard(id: 0x00_3C)
}

// swiftlint:enable identifier_name
