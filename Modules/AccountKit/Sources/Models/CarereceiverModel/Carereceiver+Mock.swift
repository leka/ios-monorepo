// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all

import SwiftUI

public extension Carereceiver {
    // swiftlint:disable line_length
    static var mockCarereceiversSet: [Carereceiver] =
    [
        Carereceiver(id: UUID().uuidString, username: "Peet", avatar: Avatars.categories[2].avatars[2], reinforcer: .rainbow),
        Carereceiver(id: UUID().uuidString, username: "Rounhaa", avatar: Avatars.categories[4].avatars[0], reinforcer: .sprinkles),
        Carereceiver(id: UUID().uuidString, username: "Selug", avatar: Avatars.categories[5].avatars[1], reinforcer: .spinBlinkBlueViolet),
        Carereceiver(id: UUID().uuidString, username: "Luther", avatar: Avatars.categories[1].avatars[2], reinforcer: .spinBlinkGreenOff),
        Carereceiver(id: UUID().uuidString, username: "Abel", avatar: Avatars.categories[2].avatars[3], reinforcer: .fire),
    ]
    // swiftlint:enable line_length
}

// swiftlint:enable all
// swiftformat:enable all
