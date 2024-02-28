// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - EditCaregiverView

struct EditCaregiverView: View {
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
                            TextField("", text: self.$modifiedCaregiver.firstName)
                                .multilineTextAlignment(.trailing)
                        }
                        LabeledContent(String(l10n.CaregiverCreation.caregiverNameLabel.characters)) {
                            TextField("", text: self.$modifiedCaregiver.lastName)
                                .multilineTextAlignment(.trailing)
                        }
                    }

                    Section {
                        self.professionPickerButton
                    }

                    Section {
                        AppearanceRow(caregiver: self.$modifiedCaregiver)
                        AccentColorRow(caregiver: self.$modifiedCaregiver)
                    }
                }
            }
            .navigationTitle(String(l10n.EditCaregiverView.navigationTitle.characters))
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(String(l10n.EditCaregiverView.closeButtonLabel.characters)) {
                        self.rootOwnerViewModel.isEditCaregiverViewPresented = false
                        self.styleManager.colorScheme = self.modifiedCaregiver.colorScheme
                        self.styleManager.accentColor = self.modifiedCaregiver.colorTheme.color
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(l10n.EditCaregiverView.saveButtonLabel.characters)) {
                        // TODO: (@mathieu) - Add Firestore logic
                        self.rootOwnerViewModel.isEditCaregiverViewPresented = false
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
    @State private var isProfessionPickerPresented: Bool = false

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
        .sheet(isPresented: self.$isAvatarPickerPresented) {
            AvatarPicker(avatar: self.$modifiedCaregiver.avatar)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var professionPickerButton: some View {
        VStack(alignment: .leading) {
            Button {
                self.isProfessionPickerPresented = true
            } label: {
                Text(l10n.CaregiverCreation.professionLabel)
                    .font(.body)
            }
            .sheet(isPresented: self.$isProfessionPickerPresented) {
                ProfessionPicker(caregiver: self.$modifiedCaregiver)
            }

            if !self.modifiedCaregiver.professions.isEmpty {
                ForEach(self.modifiedCaregiver.professions, id: \.self) { id in
                    let profession = Professions.profession(for: id)!
                    ProfessionPicker.ProfessionTag(profession: profession, caregiver: self.$modifiedCaregiver)
                }
            }
        }
    }
}

#Preview {
    EditCaregiverView(modifiedCaregiver: Caregiver())
}
