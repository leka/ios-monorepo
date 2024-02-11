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
                Form {
                    Section {
                        self.avatarPickerButton
                            .listRowBackground(Color.clear)
                    }

                    Section {
                        LabeledContent(String(l10n.CaregiverCreation.caregiverNameLabel.characters)) {
                            TextField("Nom", text: self.$modifiedCaregiver.name)
                                .multilineTextAlignment(.trailing)
                        }
                    }

                    Section {
                        self.professionNavigationLink
                    }

                    Section {
                        AppearanceRow(caregiver: self.$modifiedCaregiver)
                        AccentColorRow(caregiver: self.$modifiedCaregiver)
                    }
                }
            }
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
    @State private var isAvatarPickerPresented: Bool = false

    private var avatarPickerButton: some View {
        Button {
            self.isAvatarPickerPresented = true
        } label: {
            VStack(alignment: .center, spacing: 15) {
                AvatarPicker.ButtonLabel(image: self.modifiedCaregiver.avatar)
                Text(l10n.CaregiverCreation.avatarChoiceButton)
                    .font(.headline)
            }
        }
        .navigationDestination(isPresented: self.$isAvatarPickerPresented) {
            AvatarPicker(avatar: self.$modifiedCaregiver.avatar)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var professionNavigationLink: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                ProfessionPicker(caregiver: self.$modifiedCaregiver)
            } label: {
                Text(l10n.CaregiverCreation.professionLabel)
                    .font(.body)
            }

            if !self.modifiedCaregiver.professions.isEmpty {
                ForEach(self.modifiedCaregiver.professions, id: \.id) { profession in
                    ProfessionPicker.ProfessionTag(profession: profession, caregiver: self.$modifiedCaregiver)
                }
            }
        }
    }
}

#Preview {
    CaregiverSettingsView(modifiedCaregiver: Caregiver())
}
