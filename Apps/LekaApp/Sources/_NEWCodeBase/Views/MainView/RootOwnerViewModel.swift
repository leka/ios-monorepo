// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all

import AccountKit
import DesignKit
import SwiftUI

class RootOwnerViewModel: ObservableObject {
    // MARK: Lifecycle

    private init() {
        // nothing to do
    }

    // MARK: Internal

    static let shared = RootOwnerViewModel()

    @Published var currentCaregiver: Caregiver?
    @Published var currentCarereceiver: Carereceiver?

    @Published var isSettingsViewPresented = false

    @Published var isEditCaregiverViewPresented = false
    @Published var isEditCarereceiverViewPresented = false

    @Published var showConfirmCredentialsChange: Bool = false
    @Published var showConfirmDisconnection: Bool = false
    @Published var showConfirmDeleteAccount: Bool = false

    // swiftlint:disable line_length
    @Published var mockCaregiversSet: [Caregiver] = [
        Caregiver(id: UUID().uuidString, firstName: "Chantal", lastName: "Goya", avatar: Avatars.categories[0].avatars[2], professions: [Professions.list[6].id]),
        Caregiver(id: UUID().uuidString, firstName: "Gaëtan", lastName: "Roussel", avatar: "boy1", professions: [Professions.list[9].id], colorScheme: .dark, colorTheme: .green),
        Caregiver(id: UUID().uuidString, firstName: "Fabrizio", lastName: "Ferrari", avatar: Avatars.categories[4].avatars[1], professions: [Professions.list[10].id]),
        Caregiver(id: UUID().uuidString, firstName: "Hakima", lastName: "Queen", avatar: "girl10", professions: [Professions.list[10].id, Professions.list[1].id]),
        Caregiver(id: UUID().uuidString, firstName: "Eric", lastName: "Clapton", avatar: Avatars.categories[1].avatars[0], professions: [Professions.list[10].id]),
        Caregiver(id: UUID().uuidString, firstName: "Razmo", lastName: "Kets", avatar: Avatars.categories[2].avatars[2], professions: [Professions.list[5].id], colorScheme: .dark, colorTheme: .orange),
        Caregiver(id: UUID().uuidString, firstName: "Corinne", lastName: "Lepage", avatar: Avatars.categories[5].avatars[1], professions: [Professions.list[4].id]),
        Caregiver(id: UUID().uuidString, firstName: "Alphonso", lastName: "Mango", avatar: Avatars.categories[4].avatars[1], professions: [Professions.list[0].id]),
        Caregiver(id: UUID().uuidString, firstName: "Gargantua", lastName: "Pantagruel", avatar: Avatars.categories[3].avatars[2], professions: [Professions.list[2].id]),
    ]

    @Published var mockCarereceiversSet: [Carereceiver] = [
        Carereceiver(id: UUID().uuidString, username: "Peet", avatar: Avatars.categories[2].avatars[2], reinforcer: 1),
        Carereceiver(id: UUID().uuidString, username: "Rounhaa", avatar: Avatars.categories[4].avatars[0], reinforcer: 3),
        Carereceiver(id: UUID().uuidString, username: "Selug", avatar: Avatars.categories[5].avatars[1], reinforcer: 4),
        Carereceiver(id: UUID().uuidString, username: "Luther", avatar: Avatars.categories[1].avatars[2], reinforcer: 5),
        Carereceiver(id: UUID().uuidString, username: "Abel", avatar: Avatars.categories[2].avatars[3], reinforcer: 2),
    ]
    // swiftlint:enable line_length

    func getReinforcerFor(index: Int) -> UIImage {
        switch index {
            case 2: DesignKitAsset.Reinforcers.spinBlinkBlueViolet.image
            case 3: DesignKitAsset.Reinforcers.fire.image
            case 4: DesignKitAsset.Reinforcers.sprinkles.image
            case 5: DesignKitAsset.Reinforcers.rainbow.image
            default: DesignKitAsset.Reinforcers.spinBlinkGreenOff.image
        }
    }
}

// swiftlint:enable all
// swiftformat:enable all
