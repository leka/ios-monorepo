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

    @Published var currentCaregiver: Caregiver_OLD?
    @Published var currentCarereceiver: Carereceiver_OLD?

    @Published var isSettingsViewPresented = false

    @Published var isEditCaregiverViewPresented = false
    @Published var isEditCarereceiverViewPresented = false

    @Published var showConfirmCredentialsChange: Bool = false
    @Published var showConfirmDisconnection: Bool = false
    @Published var showConfirmDeleteAccount: Bool = false

    @Published var mockCaregiversSet: [Caregiver_OLD] = [
        Caregiver_OLD(name: "Chantal", avatar: DesignKitAsset.Avatars.avatarsBoy4f.name, professions: [Professions.list[6]]),
        Caregiver_OLD(name: "Gaëtan", avatar: DesignKitAsset.Avatars.avatarsLekaSunglassesBlue.name, professions: [Professions.list[9]], colorScheme: .dark, accentColor: .green),
        Caregiver_OLD(name: "Fabrizio", avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsFarmBirdYellow0071.name, professions: [Professions.list[10]]),
        Caregiver_OLD(name: "Hakima", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsPearYellow00FC.name, professions: [Professions.list[10], Professions.list[1]]),
        Caregiver_OLD(name: "Eric", avatar: DesignKitAsset.Avatars.avatarsBoy2a.name, professions: [Professions.list[10]]),
        Caregiver_OLD(name: "Razmo", avatar: DesignKitAsset.Avatars.avatarsBoy3b.name, professions: [Professions.list[5]], colorScheme: .dark, accentColor: .orange),
        Caregiver_OLD(name: "Corinne", avatar: DesignKitAsset.Avatars.avatarsGirl1d.name, professions: [Professions.list[4]]),
        Caregiver_OLD(name: "Alphonso", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsAppleRed0101.name, professions: [Professions.list[0]]),
        Caregiver_OLD(name: "Gargantua", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsCherryRed00FF.name, professions: [Professions.list[2]]),
    ]

    @Published var mockCarereceiversSet: [Carereceiver_OLD] = [
        Carereceiver_OLD(name: "Peet", avatar: DesignKitAsset.Avatars.avatarsLekaAstronaut.name, reinforcer: 1),
        Carereceiver_OLD(name: "Rounhaa", avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestSquirrelOrange005C.name, reinforcer: 3),
        Carereceiver_OLD(name: "Selug", avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaCrabRed003E.name, reinforcer: 4),
        Carereceiver_OLD(name: "Luther", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsAppleRed0101.name, reinforcer: 5),
        Carereceiver_OLD(name: "Abel", avatar: DesignKitAsset.Avatars.avatarsBoy1g.name, reinforcer: 2),
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
