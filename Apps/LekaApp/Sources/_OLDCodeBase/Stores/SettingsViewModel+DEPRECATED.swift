// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

class SettingsViewModelDeprecated: ObservableObject {
    // Connexion-related properties - Settings
    @Published var companyIsLoggingIn: Bool = false
    @Published var companyIsConnected: Bool = false
    @Published var exploratoryModeIsOn: Bool = false
    @Published var showSwitchOffExploratoryAlert: Bool = false

    @Published var showConfirmDisconnection: Bool = false
    @Published var showConfirmDeleteAccount: Bool = false

    // This will go later in UIEvents Environment
    @Published var showConnectInvite: Bool = false
}
