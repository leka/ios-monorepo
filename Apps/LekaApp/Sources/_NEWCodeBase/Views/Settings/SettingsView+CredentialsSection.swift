// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LocalizationKit
import SwiftUI

// MARK: - SettingsView.CredentialsSection

extension SettingsView {
    struct CredentialsSection: View {
        // MARK: Internal

        @ObservedObject var rootOwnerViewModel: RootOwnerViewModel = .shared

        var body: some View {
            Section(String(l10n.SettingsView.CredentialsSection.header.characters)) {
                LabeledContent {
                    Text(self.authManager.currentUserEmail ?? "")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                } label: {
                    Text(l10n.SettingsView.CredentialsSection.emailLabel)
                }

                Button {
                    self.rootOwnerViewModel.showConfirmCredentialsChange = true
                } label: {
                    Text(l10n.SettingsView.CredentialsSection.ChangeCredentials.buttonLabel)
                        .foregroundColor(.accentColor)
                }
            }
            .alert(String(l10n.SettingsView.CredentialsSection.ChangeCredentials.alertTitle.characters),
                   isPresented: self.$rootOwnerViewModel.showConfirmCredentialsChange) {} message: {
                Text(l10n.SettingsView.CredentialsSection.ChangeCredentials.alertMessage)
            }
            .textCase(nil)
        }

        // MARK: Private

        private var authManager = AuthManager.shared
    }
}

#Preview {
    Form {
        SettingsView.CredentialsSection()
    }
}
