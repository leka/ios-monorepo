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
        case dragAndDropToAssociate
        case danceFreeze
        case remoteStandardJoystick
        case remoteStandardArrow
        case remoteArrow
        case hideAndSeek
        case musicalInstruments
        case melody
        case pairing
    }
}
