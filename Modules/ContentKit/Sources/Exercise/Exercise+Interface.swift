// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension Exercise {
    enum Interface: String, Codable {
        case touchToSelect
        case robotThenTouchToSelect
        case robotThenTouchToSelectInRightOrder
        case listenThenTouchToSelect
        case observeThenTouchToSelect
        case dragAndDropIntoZones
        case dragAndDropToAssociate
        case danceFreeze
        case gamepadJoyStickColorPad
        case gamepadArrowPadColorPad
        case gamepadArrowPad
        case hideAndSeek
        case musicalInstruments
        case melody
        case pairing
    }
}
