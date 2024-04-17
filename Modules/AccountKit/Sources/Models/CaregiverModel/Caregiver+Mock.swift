// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all

import SwiftUI

public extension Caregiver {
    // swiftlint:disable line_length
    static var mockCaregiversSet: [Caregiver] =
    [
        Caregiver(uuid: UUID().uuidString, firstName: "Chantal", lastName: "Goya", avatar: Avatars.categories[0].avatars[2], professions: [Professions.list[6].id]),
        Caregiver(uuid: UUID().uuidString, firstName: "Gaëtan", lastName: "Roussel", avatar: "boy1", professions: [Professions.list[9].id], colorScheme: .dark, colorTheme: .green),
        Caregiver(uuid: UUID().uuidString, firstName: "Fabrizio", lastName: "Ferrari", avatar: Avatars.categories[4].avatars[1], professions: [Professions.list[10].id]),
        Caregiver(uuid: UUID().uuidString, firstName: "Hakima", lastName: "Queen", avatar: "girl10", professions: [Professions.list[10].id, Professions.list[1].id]),
        Caregiver(uuid: UUID().uuidString, firstName: "Eric", lastName: "Clapton", avatar: Avatars.categories[1].avatars[0], professions: [Professions.list[10].id]),
        Caregiver(uuid: UUID().uuidString, firstName: "Razmo", lastName: "Kets", avatar: Avatars.categories[2].avatars[2], professions: [Professions.list[5].id], colorScheme: .dark, colorTheme: .orange),
        Caregiver(uuid: UUID().uuidString, firstName: "Corinne", lastName: "Lepage", avatar: Avatars.categories[5].avatars[1], professions: [Professions.list[4].id]),
        Caregiver(uuid: UUID().uuidString, firstName: "Alphonso", lastName: "Mango", avatar: Avatars.categories[4].avatars[1], professions: [Professions.list[0].id]),
        Caregiver(uuid: UUID().uuidString, firstName: "Gargantua", lastName: "Pantagruel", avatar: Avatars.categories[3].avatars[2], professions: [Professions.list[2].id]),
    ]
    // swiftlint:enable line_length
}

// swiftlint:enable all
// swiftformat:enable all
