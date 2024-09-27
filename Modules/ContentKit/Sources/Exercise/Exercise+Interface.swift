// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension Exercise {
    enum Interface: String, Codable {
        case touchToSelect
        case robotThenTouchToSelect
        case listenThenTouchToSelect
        case observeThenTouchToSelect
        case dragAndDropIntoZones
        case listenThenDragAndDropIntoZones
        case observeThenDragAndDropIntoZones
        case robotThenDragAndDropIntoZones
        case dragAndDropToAssociate
        case listenThenDragAndDropToAssociate
        case observeThenDragAndDropToAssociate
        case robotThenDragAndDropToAssociate
        case dragAndDropInOrder
        case danceFreeze
        case superSimon
        case gamepadJoyStickColorPad
        case gamepadArrowPadColorPad
        case gamepadColorPad
        case gamepadArrowPad
        case hideAndSeek
        case musicalInstruments
        case melody
        case pairing
        case memory
    }
}
