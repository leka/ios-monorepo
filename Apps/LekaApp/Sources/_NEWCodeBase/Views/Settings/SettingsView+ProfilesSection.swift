// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - SettingsView.ProfilesSection

extension SettingsView {
    struct ProfilesSection: View {
        // MARK: Internal

        var body: some View {
            Section(String(l10n.SettingsView.ProfilesSection.header.characters)) {
                Button {
                    self.rootOwnerViewModel.isSettingsViewPresented = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.rootOwnerViewModel.currentCaregiver = nil
                    }
                } label: {
                    Label(String(l10n.SettingsView.ProfilesSection.switchProfileButtonLabel.characters), systemImage: "person.2.gobackward")
                        .foregroundColor(.accentColor)
                }
            }
        }

        // MARK: Private

        @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    }
}

#Preview {
    SettingsView.ProfilesSection()
}
