// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Exercise {

    public enum Interface: String, Codable {
        case touchToSelect
        case robotThenTouchToSelect
        case listenThenTouchToSelect
        case observeThenTouchToSelect
        case dragAndDropIntoZones
        case dragAndDropToAssociate
        case danceFreeze
        case remoteStandard
        case remoteArrow
        case hideAndSeek
        case musicalInstruments
        case melody
    }

}
