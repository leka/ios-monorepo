// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// swiftlint:disable line_length

// MARK: - SettingsView.AccountSection

extension SettingsView {
    struct AccountSection: View {
        @ObservedObject var rootOwnerViewModel: RootOwnerViewModel = .shared

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
                    self.rootOwnerViewModel.disconnect()
                } label: {
                    Text(l10n.SettingsView.AccountSection.LogOut.alertButtonLabel)
                }
            } message: {
                Text(l10n.SettingsView.AccountSection.LogOut.alertMessage)
            }
            .alert(String(l10n.SettingsView.AccountSection.DeleteAccount.alertTitle.characters), isPresented: self.$rootOwnerViewModel.showConfirmDeleteAccount) {
                Button(role: .destructive) {
                    // TODO: (@team) - Replace w/ real implementation
                    self.rootOwnerViewModel.isSettingsViewPresented = false
                    self.rootOwnerViewModel.disconnect()
                } label: {
                    Text(l10n.SettingsView.AccountSection.DeleteAccount.alertButtonLabel)
                }
            } message: {
                Text(l10n.SettingsView.AccountSection.DeleteAccount.alertMessage)
            }
        }
    }
}

// swiftlint:enable line_length

#Preview {
    SettingsView.AccountSection()
}
