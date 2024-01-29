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
                    Text(self.rootOwnerViewModel.currentCompany?.email ?? "")
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                } label: {
                    Text(l10n.SettingsView.CredentialsSection.emailLabel)
                }

                Text(l10n.SettingsView.CredentialsSection.changeCredentialsButtonLabel)
                    .foregroundColor(.accentColor)
            }
        }
    }
}

#Preview {
    Form {
        SettingsView.CredentialsSection()
    }
}
