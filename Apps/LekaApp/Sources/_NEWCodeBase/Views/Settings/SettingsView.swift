// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject var styleManager: StyleManager = .shared

    var body: some View {
        NavigationStack {
            Form {
                AppearanceSection()

                if self.authManager.userAuthenticationState == .loggedIn {
                    CredentialsSection()
                    AccountSection()
                }
            }
            .navigationTitle(String(l10n.SettingsView.navigationTitle.characters))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(l10n.SettingsView.closeButtonLabel.characters)) {
                        self.rootOwnerViewModel.isSettingsViewPresented = false
                    }
                }
            }
        }
        .preferredColorScheme(self.styleManager.colorScheme)
    }
}

#Preview {
    SettingsView()
}
