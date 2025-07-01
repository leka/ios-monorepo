// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - MagicCard

// swiftlint:disable identifier_name

public enum MagicCard: UInt16, CaseIterable {
    case none = 0x0000
    case emergency_stop = 0x0001
    case dice_roll = 0x0002

    case color_purple = 0x0003
    case color_indigo = 0x0004
    case color_blue = 0x0005
    case color_green = 0x0006
    case color_yellow = 0x0007
    case color_orange = 0x0008
    case color_red = 0x0009

    case number_0 = 0x000A
    case number_1 = 0x000B
    case number_2 = 0x000C
    case number_3 = 0x000D
    case number_4 = 0x000E
    case number_5 = 0x000F
    case number_6 = 0x0010
    case number_7 = 0x0011
    case number_8 = 0x0012
    case number_9 = 0x0013
    case number_10 = 0x0014

    case shape_square = 0x0015
    case shape_circle = 0x0016
    case shape_triangle = 0x0017
    case shape_star = 0x0018

    case activity_music_quest = 0x0019
    case activity_super_simon = 0x001A
    case activity_colored_quest = 0x001B
    case activity_music_colored_board = 0x001C
    case activity_hide_and_seek = 0x001D
    case activity_colors_and_sounds = 0x001E
    case activity_magic_objects = 0x001F
    case activity_dance_freeze = 0x0020

    case gamepad_joystick_color_pad = 0x0021
    case gamepad_arrow_pad_big = 0x0022

    case reinforcer_1_blink_green = 0x0023
    case reinforcer_2_spin_blink = 0x0024
    case reinforcer_3_fire = 0x0025
    case reinforcer_4_sprinkles = 0x0026
    case reinforcer_5_rainbow = 0x0027

    case emotion_fear_child = 0x0028
    case emotion_disgust_child = 0x0029
    case emotion_anger_child = 0x002A
    case emotion_joy_child = 0x002B
    case emotion_sadness_child = 0x002C
    case emotion_fear_leka = 0x002D
    case emotion_disgust_leka = 0x002E
    case emotion_anger_leka = 0x002F
    case emotion_joy_leka = 0x0030
    case emotion_sadness_leka = 0x0031

    case vegetable_carrot_orange = 0x0032
    case vegetable_potato_yellow = 0x0033
    case vegetable_salad_green = 0x0034
    case vegetable_mushroom_grey = 0x0035
    case fruit_strawberry_red = 0x0036
    case fruit_cherry_pink = 0x0037
    case fruit_apple_green = 0x0038
    case fruit_banana_yellow = 0x0039
    case fruit_grapes_black = 0x003A

    case math_arithmetic_substraction_sign_minus = 0x003B
    case math_arithmetic_addition_sign_plus = 0x003C

    // MARK: Lifecycle

    public init(id: UInt16) {
        self = MagicCard(rawValue: id) ?? .none
    }

    public init(name: String) {
        guard let match = Self.allCases.first(where: { name == "\($0)" }) else {
            self = .none
            return
        }
        self = match
    }
}

// swiftlint:enable identifier_name
