// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    @Environment(\.openURL) private var openURL

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @Binding var isCaregiverPickerPresented: Bool

    var body: some View {
        NavigationStack {
            Form {
                CredentialsSection()
                ProfilesSection(isCaregiverPickerPresented: self.$isCaregiverPickerPresented)
                AccountSection()

                Section {
                    Button(String(l10n.SettingsView.ChangeLanguageSection.buttonLabel.characters), systemImage: "globe") {
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }

                        self.openURL(settingsURL)
                    }
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
    SettingsView(isCaregiverPickerPresented: .constant(false))
}
