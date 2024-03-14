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

    @Environment(\.dismiss) var dismiss
    @State var modifiedCaregiver: Caregiver

    var body: some View {
        VStack(spacing: 40) {
            Form {
                Section {
                    self.avatarPickerButton
                        .buttonStyle(.borderless)
                        .listRowBackground(Color.clear)
                }

                Section {
                    LabeledContent(String(l10n.CaregiverCreation.caregiverFirstNameLabel.characters)) {
                        TextField("", text: self.$modifiedCaregiver.firstName)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.secondary)
                    }
                    LabeledContent(String(l10n.CaregiverCreation.caregiverLastNameLabel.characters)) {
                        TextField("", text: self.$modifiedCaregiver.lastName)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.secondary)
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(String(l10n.EditCaregiverView.closeButtonLabel.characters)) {
                    self.styleManager.colorScheme = self.caregiverManagerViewModel.currentCaregiver!.colorScheme
                    self.styleManager.accentColor = self.caregiverManagerViewModel.currentCaregiver!.colorTheme.color
                    self.dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(l10n.EditCaregiverView.saveButtonLabel.characters)) {
                    self.caregiverManager.updateCaregiver(caregiver: &self.modifiedCaregiver)
                    self.dismiss()
                }
            }
        }
        .preferredColorScheme(self.styleManager.colorScheme)
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
    @State private var isAvatarPickerPresented: Bool = false
    @State private var isProfessionPickerPresented: Bool = false

    var caregiverManager: CaregiverManager = .shared

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
            NavigationStack {
                AvatarPicker(selectedAvatar: self.modifiedCaregiver.avatar,
                             onValidate: { avatar in
                                 self.modifiedCaregiver.avatar = avatar
                             })
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var professionPickerButton: some View {
        VStack(alignment: .leading) {
            LabeledContent(String(l10n.CaregiverCreation.professionLabel.characters)) {
                Button {
                    self.isProfessionPickerPresented = true
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: self.$isProfessionPickerPresented) {
                    NavigationStack {
                        ProfessionPicker(selectedProfessionsIDs: self.modifiedCaregiver.professions,
                                         onValidate: { professions in
                                             self.modifiedCaregiver.professions = professions
                                         })
                                         .navigationBarTitleDisplayMode(.inline)
                    }
                }
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
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                EditCaregiverView(modifiedCaregiver: Caregiver())
            }
        }
}
