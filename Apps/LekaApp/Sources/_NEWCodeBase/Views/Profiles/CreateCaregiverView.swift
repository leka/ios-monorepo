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
    var onDismissAction: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    self.avatarNavigationLink

                    TextFieldDefault(label: String(l10n.CaregiverCreation.caregiverNameLabel.characters),
                                     entry: self.$rootOwnerViewModel.bufferCaregiver.name)
                        .frame(width: 400)

                    self.professionNavigationLink

                    Button(String(l10n.CaregiverCreation.registerProfilButton.characters)) {
                        withAnimation {
                            self.isPresented.toggle()
                            self.onDismissAction()
                        }
                        // TODO: (@team) : add the caregiver profile to the account
                        // TODO: (@team) : assign the caregiver profile as the current selected one
                        self.rootOwnerViewModel.mockCaregiversSet.append(self.rootOwnerViewModel.bufferCaregiver)
                    }
                    .disabled(self.rootOwnerViewModel.bufferCaregiver.name.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .navigationTitle(String(l10n.CaregiverCreation.title.characters))
            }
        }
    }

    // MARK: Private

    @ObservedObject private var rootOwnerViewModel = RootOwnerViewModel.shared

    private var avatarNavigationLink: some View {
        NavigationLink {
            AvatarPicker(avatar: self.$rootOwnerViewModel.bufferCaregiver.avatar)
        } label: {
            VStack(spacing: 15) {
                AvatarPicker.ButtonLabel(image: self.rootOwnerViewModel.bufferCaregiver.avatar)
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
                    ProfessionPicker()
                } label: {
                    Label(String(l10n.CaregiverCreation.professionAddButton.characters), systemImage: "plus")
                }
            }

            if !self.rootOwnerViewModel.bufferCaregiver.professions.isEmpty {
                ForEach(self.rootOwnerViewModel.bufferCaregiver.professions, id: \.self) { profession in
                    ProfessionPicker.ProfessionTag(profession: profession)
                }
            }
        }
        .frame(width: 400)
    }
}

// MARK: - l10n.CaregiverCreation

// swiftlint:disable line_length

extension l10n {
    enum CaregiverCreation {
        static let title = LocalizedString("lekaapp.caregiver_creation.title", value: "Create a caregiver profile", comment: "Caregiver creation title")

        static let avatarChoiceButton = LocalizedString("lekaapp.caregiver_creation.avatar_choice_button", value: "Choose an avatar", comment: "Caregiver creation avatar choice button label")

        static let caregiverNameLabel = LocalizedString("lekaapp.caregiver_creation.caregiver_name_label", value: "Caregiver name", comment: "Caregiver creation caregiver name textfield label")

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