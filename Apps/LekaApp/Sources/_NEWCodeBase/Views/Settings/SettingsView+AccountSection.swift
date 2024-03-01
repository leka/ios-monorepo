// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// swiftlint:disable line_length

// MARK: - SettingsView.AccountSection

extension SettingsView {
    struct AccountSection: View {
        // MARK: Internal

        var body: some View {
            Section("") {
                Button {
                    self.rootOwnerViewModel.showConfirmDisconnection = true
                } label: {
                    Label(String(l10n.SettingsView.AccountSection.LogOut.buttonLabel.characters), systemImage: "rectangle.portrait.and.arrow.forward")
                        .foregroundColor(.accentColor)
                }

                Button(role: .destructive) {
                    self.rootOwnerViewModel.showConfirmDeleteAccount = true
                } label: {
                    Label(String(l10n.SettingsView.AccountSection.DeleteAccount.buttonLabel.characters), systemImage: "trash")
                        .foregroundStyle(.red)
                }
            }
            .alert(String(l10n.SettingsView.AccountSection.LogOut.alertTitle.characters), isPresented: self.$rootOwnerViewModel.showConfirmDisconnection) {
                Button(role: .destructive) {
                    self.rootOwnerViewModel.isSettingsViewPresented = false
                    self.authManager.signOut()
                    self.reset()
                } label: {
                    Text(l10n.SettingsView.AccountSection.LogOut.alertButtonLabel)
                }
            } message: {
                Text(l10n.SettingsView.AccountSection.LogOut.alertMessage)
            }
            .alert(String(l10n.SettingsView.AccountSection.LogOut.errorAlertTitle.characters), isPresented: self.$authManagerViewModel.showErrorAlert) {
                // Nothing to do
            } message: {
                Text(self.authManagerViewModel.errorMessage)
            }
            .alert(String(l10n.SettingsView.AccountSection.DeleteAccount.alertTitle.characters), isPresented: self.$rootOwnerViewModel.showConfirmDeleteAccount) {
                // Nothing to do
            } message: {
                Text(l10n.SettingsView.AccountSection.DeleteAccount.alertMessage)
            }
            .textCase(nil)
        }

        // MARK: Private

        @ObservedObject private var caregiverManagerViewModel: CaregiverManagerViewModel = .shared
        @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
        @ObservedObject private var styleManager: StyleManager = .shared
        @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
        private var authManager = AuthManager.shared

        private func reset() {
            self.caregiverManagerViewModel.currentCaregiver = nil
            self.caregiverManagerViewModel.caregivers = []
            self.styleManager.accentColor = DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
            self.styleManager.colorScheme = .light
        }
    }
}

// swiftlint:enable line_length

#Preview {
    SettingsView.AccountSection()
}
