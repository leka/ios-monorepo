// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import RobotKit
import SwiftUI

class RootOwnerViewModel: ObservableObject {
    // MARK: Lifecycle

    private init() {
        // nothing to do
    }

    // MARK: Internal

    static let shared = RootOwnerViewModel()

    @Published var isSettingsViewPresented = false

    @Published var isEditCaregiverViewPresented = false
    @Published var isEditCarereceiverViewPresented = false
    @Published var isWelcomeViewPresented = false
    @Published var isCaregiverPickerPresented = false

    @Published var showConfirmCredentialsChange: Bool = false
    @Published var showConfirmDisconnection: Bool = false
    @Published var showConfirmDeleteAccount: Bool = false

    func getReinforcerImage(for reinforcer: Robot.Reinforcer) -> UIImage {
        switch reinforcer {
            case .spinBlinkBlueViolet: DesignKitAsset.Reinforcers.spinBlinkBlueViolet.image
            case .fire: DesignKitAsset.Reinforcers.fire.image
            case .sprinkles: DesignKitAsset.Reinforcers.sprinkles.image
            case .rainbow: DesignKitAsset.Reinforcers.rainbow.image
            default: DesignKitAsset.Reinforcers.spinBlinkGreenOff.image
        }
    }
}
