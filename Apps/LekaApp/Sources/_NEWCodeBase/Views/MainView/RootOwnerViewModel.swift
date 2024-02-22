// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

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

    @Published var mockCaregiversSet: [Caregiver] = [
        Caregiver(name: "Chantal", avatar: Avatars.categories[0].avatars[2], professions: [Professions.list[6]]),
        Caregiver(name: "Gaëtan", avatar: Avatars.categories[3].avatars[1], professions: [Professions.list[9]], colorScheme: .dark, accentColor: .green),
        Caregiver(name: "Fabrizio", avatar: Avatars.categories[4].avatars[1], professions: [Professions.list[10]]),
        Caregiver(name: "Hakima", avatar: Avatars.categories[2].avatars[1], professions: [Professions.list[10], Professions.list[1]]),
        Caregiver(name: "Eric", avatar: Avatars.categories[1].avatars[0], professions: [Professions.list[10]]),
        Caregiver(name: "Razmo", avatar: Avatars.categories[2].avatars[2], professions: [Professions.list[5]], colorScheme: .dark, accentColor: .orange),
        Caregiver(name: "Corinne", avatar: Avatars.categories[5].avatars[1], professions: [Professions.list[4]]),
        Caregiver(name: "Alphonso", avatar: Avatars.categories[4].avatars[1], professions: [Professions.list[0]]),
        Caregiver(name: "Gargantua", avatar: Avatars.categories[3].avatars[2], professions: [Professions.list[2]]),
    ]

    @Published var mockCarereceiversSet: [Carereceiver] = [
        Carereceiver(name: "Peet", avatar: Avatars.categories[2].avatars[2], reinforcer: 1),
        Carereceiver(name: "Rounhaa", avatar: Avatars.categories[4].avatars[0], reinforcer: 3),
        Carereceiver(name: "Selug", avatar: Avatars.categories[5].avatars[1], reinforcer: 4),
        Carereceiver(name: "Luther", avatar: Avatars.categories[1].avatars[2], reinforcer: 5),
        Carereceiver(name: "Abel", avatar: Avatars.categories[2].avatars[3], reinforcer: 2),
    ]

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
