// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - SettingsView.CredentialsSection

extension SettingsView {
    struct CredentialsSection: View {
        @ObservedObject var rootOwnerViewModel: RootOwnerViewModel = .shared

        var body: some View {
            Section(String(l10n.SettingsView.CredentialsSection.header.characters)) {
                LabeledContent {
                    // TODO: (@mathieu) - Add mail info with Firebase/store
                    Text("test@leka.io")
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
    }
}

#Preview {
    Form {
        SettingsView.CredentialsSection()
    }
}
