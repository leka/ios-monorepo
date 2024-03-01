// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CreateCaregiverView

struct CreateCaregiverView: View {
    // MARK: Internal

    @Binding var isPresented: Bool
    @State private var newCaregiver = Caregiver()
    var onDismissAction: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Form {
                    Section {
                        self.avatarPickerButton
                            .listRowBackground(Color.clear)
                    }

                    Section {
                        LabeledContent(String(l10n.CaregiverCreation.caregiverFirstNameLabel.characters)) {
                            TextField("", text: self.$newCaregiver.firstName)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(Color.secondary)
                        }
                        LabeledContent(String(l10n.CaregiverCreation.caregiverLastNameLabel.characters)) {
                            TextField("", text: self.$newCaregiver.lastName)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(Color.secondary)
                        }
                    }

                    Section {
                        self.professionPickerButton
                    }

                    Button(String(l10n.CaregiverCreation.registerProfilButton.characters)) {
                        withAnimation {
                            self.isPresented.toggle()
                            self.onDismissAction()
                        }
                        if self.newCaregiver.avatar.isEmpty {
                            self.newCaregiver.avatar = Avatars.categories.first!.avatars.randomElement()!
                        }
                        self.caregiverManager.addCaregiver(caregiver: self.newCaregiver)
                    }
                    .disabled(self.newCaregiver.firstName.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle(String(l10n.CaregiverCreation.title.characters))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: Private

    @State private var isAvatarPickerPresented: Bool = false
    @State private var isProfessionPickerPresented: Bool = false
    var caregiverManager: CaregiverManager = .shared

    private var avatarPickerButton: some View {
        Button {
            self.isAvatarPickerPresented = true
        } label: {
            VStack(alignment: .center, spacing: 15) {
                AvatarPicker.ButtonLabel(image: self.newCaregiver.avatar)
                Text(l10n.CaregiverCreation.avatarChoiceButton)
                    .font(.headline)
            }
        }
        .sheet(isPresented: self.$isAvatarPickerPresented) {
            NavigationStack {
                AvatarPicker(avatar: self.$newCaregiver.avatar)
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
                        ProfessionPicker(caregiver: self.$newCaregiver)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }

            if !self.newCaregiver.professions.isEmpty {
                ForEach(self.newCaregiver.professions, id: \.self) { id in
                    let profession = Professions.profession(for: id)!
                    ProfessionPicker.ProfessionTag(profession: profession, caregiver: self.$newCaregiver)
                }
            }
        }
    }
}

// MARK: - l10n.CaregiverCreation

// swiftlint:disable line_length

extension l10n {
    enum CaregiverCreation {
        static let title = LocalizedString("lekaapp.caregiver_creation.title", value: "Create a caregiver profile", comment: "Caregiver creation title")

        static let avatarChoiceButton = LocalizedString("lekaapp.caregiver_creation.avatar_choice_button", value: "Choose an avatar", comment: "Caregiver creation avatar choice button label")

        static let caregiverFirstNameLabel = LocalizedString("lekaapp.caregiver_creation.caregiver_first_name_label", value: "First name", comment: "Caregiver creation caregiver first name textfield label")

        static let caregiverLastNameLabel = LocalizedString("lekaapp.caregiver_creation.caregiver_last_name_label", value: "Last name", comment: "Caregiver creation caregiver last name textfield label")

        static let professionLabel = LocalizedString("lekaapp.caregiver_creation.profession_label", value: "Profession(s)", comment: "Caregiver creation profession label above profession selection button")

        static let professionAddButton = LocalizedString("lekaapp.caregiver_creation.profession_add_button", value: "Add", comment: "Caregiver creation profession add button label")

        static let registerProfilButton = LocalizedString("lekaapp.caregiver_creation.register_profil_button", value: "Register profile", comment: "Caregiver creation register profil button label")
    }
}

// swiftlint:enable line_length

#Preview {
    CreateCaregiverView(isPresented: .constant(true)) {
        print("Caregiver saved")
    }
}
