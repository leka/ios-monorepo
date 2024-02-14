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
    @Published var isCaregiverPickerViewPresented = false
    @Published var isCarereceiverPickerViewPresented = false

    @Published var showConfirmCredentialsChange: Bool = false
    @Published var showConfirmDisconnection: Bool = false
    @Published var showConfirmDeleteAccount: Bool = false

    @Published var mockCaregiversSet: [Caregiver] = [
        Caregiver(name: "Chantal", avatar: DesignKitAsset.Avatars.avatarsBoy4f.name, professions: [Professions.list[6]]),
        Caregiver(name: "Gaëtan", avatar: DesignKitAsset.Avatars.avatarsLekaSunglassesBlue.name, professions: [Professions.list[9]], colorScheme: .dark, accentColor: .green),
        Caregiver(name: "Fabrizio", avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsFarmBirdYellow0071.name, professions: [Professions.list[10]]),
        Caregiver(name: "Hakima", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsPearYellow00FC.name, professions: [Professions.list[10], Professions.list[1]]),
        Caregiver(name: "Eric", avatar: DesignKitAsset.Avatars.avatarsBoy2a.name, professions: [Professions.list[10]]),
        Caregiver(name: "Razmo", avatar: DesignKitAsset.Avatars.avatarsBoy3b.name, professions: [Professions.list[5]], colorScheme: .dark, accentColor: .orange),
        Caregiver(name: "Corinne", avatar: DesignKitAsset.Avatars.avatarsGirl1d.name, professions: [Professions.list[4]]),
        Caregiver(name: "Alphonso", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsAppleRed0101.name, professions: [Professions.list[0]]),
        Caregiver(name: "Gargantua", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsCherryRed00FF.name, professions: [Professions.list[2]]),
    ]

    @Published var mockCarereceiversSet: [Carereceiver] = [
        Carereceiver(name: "Peet", avatar: DesignKitAsset.Avatars.avatarsLekaAstronaut.name, reinforcer: 1),
        Carereceiver(name: "Rounhaa", avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsForestSquirrelOrange005C.name, reinforcer: 3),
        Carereceiver(name: "Selug", avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsSeaCrabRed003E.name, reinforcer: 4),
        Carereceiver(name: "Luther", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsAppleRed0101.name, reinforcer: 5),
        Carereceiver(name: "Abel", avatar: DesignKitAsset.Avatars.avatarsBoy1g.name, reinforcer: 2),
    ]

    var isCarereceiverSelected: Bool {
        self.currentCarereceiver != nil
    }

    func getReinforcerFor(index: Int) -> UIImage {
        switch index {
            case 2: DesignKitAsset.Reinforcers.spinBlinkBlueViolet.image
            case 3: DesignKitAsset.Reinforcers.fire.image
            case 4: DesignKitAsset.Reinforcers.sprinkles.image
            case 5: DesignKitAsset.Reinforcers.rainbow.image
            default: DesignKitAsset.Reinforcers.spinBlinkGreenOff.image
        }
    }

    func disconnect() {
        self.currentCaregiver = nil
        self.currentCarereceiver = nil
    }
}
