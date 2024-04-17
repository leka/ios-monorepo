// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension Caregiver {
    static var mockCaregiversSet: [Caregiver] =
        [
            Caregiver(
                id: UUID().uuidString,
                firstName: "Chantal",
                lastName: "Goya",
                avatar: Avatars.categories[0].avatars[2],
                professions: [
                    Professions.list[6].id,
                ]
            ),
            Caregiver(
                id: UUID().uuidString,
                firstName: "Gaëtan",
                lastName: "Roussel",
                avatar: "boy1",
                professions: [
                    Professions.list[9].id,
                ],
                colorScheme: .dark,
                colorTheme: .green
            ),
            Caregiver(
                id: UUID().uuidString,
                firstName: "Fabrizio",
                lastName: "Ferrari",
                avatar: Avatars.categories[4].avatars[1],
                professions: [
                    Professions.list[10].id,
                ]
            ),
            Caregiver(
                id: UUID().uuidString,
                firstName: "Hakima",
                lastName: "Queen",
                avatar: "girl10",
                professions: [
                    Professions.list[10].id,
                    Professions.list[1].id,
                ]
            ),
            Caregiver(
                id: UUID().uuidString,
                firstName: "Eric",
                lastName: "Clapton",
                avatar: Avatars.categories[1].avatars[0],
                professions: [
                    Professions.list[10].id,
                ]
            ),
            Caregiver(
                id: UUID().uuidString,
                firstName: "Razmo",
                lastName: "Kets",
                avatar: Avatars.categories[2].avatars[2],
                professions: [
                    Professions.list[5].id,
                ],
                colorScheme: .dark,
                colorTheme: .orange
            ),
            Caregiver(
                id: UUID().uuidString,
                firstName: "Corinne",
                lastName: "Lepage",
                avatar: Avatars.categories[5].avatars[1],
                professions: [
                    Professions.list[4].id,
                ]
            ),
            Caregiver(
                id: UUID().uuidString,
                firstName: "Alphonso",
                lastName: "Mango",
                avatar: Avatars.categories[4].avatars[1],
                professions: [
                    Professions.list[0].id,
                ]
            ),
            Caregiver(
                id: UUID().uuidString,
                firstName: "Gargantua",
                lastName: "Pantagruel",
                avatar: Avatars.categories[3].avatars[2],
                professions: [
                    Professions.list[2].id,
                ]
            ),
        ]
}
