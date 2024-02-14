// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

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
                        LabeledContent(String(l10n.CaregiverCreation.caregiverNameLabel.characters)) {
                            TextField("", text: self.$newCaregiver.name)
                                .multilineTextAlignment(.trailing)
                        }
                    }

                    Section {
                        self.professionNavigationLink
                    }

                    Button(String(l10n.CaregiverCreation.registerProfilButton.characters)) {
                        withAnimation {
                            self.isPresented.toggle()
                            self.onDismissAction()
                        }
                        if self.newCaregiver.avatar.isEmpty {
                            self.newCaregiver.avatar = AvatarSets.weather.content.images.randomElement()!
                        }
                        // TODO: (@team) : add the caregiver profile to the account
                        // TODO: (@team) : assign the caregiver profile as the current selected one
                        self.rootOwnerViewModel.mockCaregiversSet.append(self.newCaregiver)
                    }
                    .disabled(self.newCaregiver.name.isEmpty)
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

    @ObservedObject private var rootOwnerViewModel = RootOwnerViewModel.shared
    @State private var isAvatarPickerPresented: Bool = false

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
        .navigationDestination(isPresented: self.$isAvatarPickerPresented) {
            AvatarPicker(avatar: self.$newCaregiver.avatar)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var professionNavigationLink: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                ProfessionPicker(caregiver: self.$newCaregiver)
            } label: {
                Text(l10n.CaregiverCreation.professionLabel)
                    .font(.body)
            }

            if !self.newCaregiver.professions.isEmpty {
                ForEach(self.newCaregiver.professions, id: \.id) { profession in
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

        static let caregiverNameLabel = LocalizedString("lekaapp.caregiver_creation.caregiver_name_label", value: "Name", comment: "Caregiver creation caregiver name textfield label")

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
