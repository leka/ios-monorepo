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

    @Published var currentCarereceiver: Carereceiver?

    @Published var isSettingsViewPresented = false

    @Published var isEditCaregiverViewPresented = false
    @Published var isEditCarereceiverViewPresented = false
    @Published var isWelcomeViewPresented = false
    @Published var isCaregiverPickerPresented = false

    @Published var showConfirmCredentialsChange: Bool = false
    @Published var showConfirmDisconnection: Bool = false
    @Published var showConfirmDeleteAccount: Bool = false

    @Published var mockCarereceiversSet: [Carereceiver] = [
        Carereceiver(id: UUID().uuidString, username: "Peet", avatar: Avatars.categories[2].avatars[2], reinforcer: 1),
        Carereceiver(id: UUID().uuidString, username: "Rounhaa", avatar: Avatars.categories[4].avatars[0], reinforcer: 3),
        Carereceiver(id: UUID().uuidString, username: "Selug", avatar: Avatars.categories[5].avatars[1], reinforcer: 4),
        Carereceiver(id: UUID().uuidString, username: "Luther", avatar: Avatars.categories[1].avatars[2], reinforcer: 5),
        Carereceiver(id: UUID().uuidString, username: "Abel", avatar: Avatars.categories[2].avatars[3], reinforcer: 2),
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
