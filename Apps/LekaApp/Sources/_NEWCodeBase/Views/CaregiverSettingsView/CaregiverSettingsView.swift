// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CaregiverSettingsView

struct CaregiverSettingsView: View {
    // MARK: Internal

    @State var modifiedCaregiver: Caregiver

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                self.avatarNavigationLink

                TextFieldDefault(label: String(l10n.CaregiverCreation.caregiverNameLabel.characters),
                                 entry: self.$modifiedCaregiver.name)

                self.professionNavigationLink

                AppearanceRow(caregiver: self.$modifiedCaregiver)
                AccentColorRow(caregiver: self.$modifiedCaregiver)
            }
            .frame(maxWidth: 500)
            .navigationTitle(String(l10n.CaregiverSettingsView.navigationTitle.characters) + self.modifiedCaregiver.name)
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(String(l10n.CaregiverSettingsView.closeButtonLabel.characters)) {
                        self.rootOwnerViewModel.isCaregiverSettingsViewPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(l10n.CaregiverSettingsView.saveButtonLabel.characters)) {
                        // TODO: (@mathieu) - Add Firestore logic
                        self.rootOwnerViewModel.isCaregiverSettingsViewPresented = false
                        self.rootOwnerViewModel.currentCaregiver = self.modifiedCaregiver
                    }
                }
            }
        }
        .preferredColorScheme(self.styleManager.colorScheme)
    }

    // MARK: Private

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    private var avatarNavigationLink: some View {
        NavigationLink {
            AvatarPicker(avatar: self.$modifiedCaregiver.avatar)
        } label: {
            VStack(spacing: 15) {
                AvatarPicker.ButtonLabel(image: self.modifiedCaregiver.avatar)
                Text(l10n.CaregiverCreation.avatarChoiceButton)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
            }
        }
    }

    private var professionNavigationLink: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(l10n.CaregiverCreation.professionLabel)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.body)

                Spacer()

                NavigationLink {
                    ProfessionPicker(caregiver: self.$modifiedCaregiver)
                } label: {
                    Label(String(l10n.CaregiverCreation.professionAddButton.characters), systemImage: "plus")
                }
            }

            if !self.modifiedCaregiver.professions.isEmpty {
                ForEach(self.modifiedCaregiver.professions, id: \.self) { profession in
                    ProfessionPicker.ProfessionTag(profession: profession, caregiver: self.$modifiedCaregiver)
                }
            }
        }
    }
}

#Preview {
    CaregiverSettingsView(modifiedCaregiver: Caregiver())
}
