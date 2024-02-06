// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

class RootOwnerViewModel: ObservableObject {
    // MARK: Lifecycle

    private init() {
        // nothing to do
    }

    // MARK: Internal

    static let shared = RootOwnerViewModel()

    @Published var currentCompany: Company?
    @Published var currentCaregiver: Caregiver?

    @Published var isWelcomeViewPresented = true
    @Published var isSettingsViewPresented = false

    @Published var showConfirmCredentialsChange: Bool = false
    @Published var showConfirmDisconnection: Bool = false
    @Published var showConfirmDeleteAccount: Bool = false

    @Published var mockCaregiversSet: [Caregiver] = [
        Caregiver(name: "Chantal", avatar: DesignKitAsset.Avatars.avatarsBoy4f.name, professions: [Caregiver.Profession.motorTherapist]),
        Caregiver(name: "Gaëtan", avatar: DesignKitAsset.Avatars.avatarsLekaSunglassesBlue.name, professions: [Caregiver.Profession.occupationalTherapist]),
        Caregiver(name: "Fabrizio", avatar: DesignKitAsset.Avatars.avatarsPictogramsAnimalsFarmBirdYellow0071.name, professions: [Caregiver.Profession.speechTherapist]),
        Caregiver(name: "Hakima", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsPearYellow00FC.name, professions: [Caregiver.Profession.other(profession: "chirurgien")]),
        Caregiver(name: "Eric", avatar: DesignKitAsset.Avatars.avatarsBoy2a.name, professions: [Caregiver.Profession.motorTherapist]),
        Caregiver(name: "Razmo", avatar: DesignKitAsset.Avatars.avatarsBoy3b.name, professions: [Caregiver.Profession.motorTherapist]),
        Caregiver(name: "Corinne", avatar: DesignKitAsset.Avatars.avatarsGirl1d.name, professions: [Caregiver.Profession.motorTherapist]),
        Caregiver(name: "Alphonso", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsAppleRed0101.name, professions: [Caregiver.Profession.motorTherapist]),
        Caregiver(name: "Gargantua", avatar: DesignKitAsset.Avatars.avatarsPictogramsFoodsFruitsCherryRed00FF.name, professions: [Caregiver.Profession.motorTherapist]),
    ]

    var isCompanyConnected: Bool {
        self.currentCompany != nil
    }

    func disconnect() {
        self.currentCompany = nil
        self.currentCaregiver = nil
    }
}
