// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CreateCaregiverViewModel

class CreateCaregiverViewModel: ObservableObject {
    // MARK: Internal

    var caregiverManager: CaregiverManager = .shared

    // MARK: - Public functions

    func createCaregiver(caregiver: Caregiver) {
        self.caregiverManager.createCaregiver(caregiver: caregiver)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        print("Caregiver Creation successful.")
                    case let .failure(error):
                        print("Caregiver Creation failed with error: \(error)")
                }
            }, receiveValue: { _ in
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - CreateCaregiverView

struct CreateCaregiverView: View {
    // MARK: Lifecycle

    init(onClose: (() -> Void)? = nil) {
        self.onClose = onClose
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    var onClose: (() -> Void)?

    var caregiverManager: CaregiverManager = .shared

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
                        TextField("", text: self.$newCaregiver.firstName, prompt: self.placeholderFirstName)
                            .textContentType(.givenName)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.secondary)
                    }
                    LabeledContent(String(l10n.CaregiverCreation.caregiverLastNameLabel.characters)) {
                        TextField("", text: self.$newCaregiver.lastName, prompt: self.placeholderLastName)
                            .textContentType(.familyName)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.secondary)
                    }
                }

                Section {
                    ProfessionListView(caregiver: self.$newCaregiver)
                }

                Button(String(l10n.CaregiverCreation.createProfileButtonLabel.characters)) {
                    if self.newCaregiver.avatar.isEmpty {
                        self.newCaregiver.avatar = Avatars.categories.first!.avatars.randomElement()!
                    }
                    self.viewModel.createCaregiver(caregiver: self.newCaregiver)
                    withAnimation {
                        self.dismiss()
                    }
                }
                .disabled(self.newCaregiver.firstName.isEmpty)
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(String(l10n.CaregiverCreation.title.characters))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.dismiss()
                } label: {
                    Text(l10n.CarereceiverCreation.closeButtonLabel)
                }
            }
        }
        .onDisappear { self.onClose?() }
    }

    // MARK: Private

    @StateObject private var viewModel = CreateCaregiverViewModel()

    @State private var newCaregiver = Caregiver()
    @State private var isAvatarPickerPresented: Bool = false
    @State private var cancellables = Set<AnyCancellable>()

    private var placeholderFirstName = Text(String(String(l10n.CaregiverCreation.caregiverPlaceholderFirstName.characters)))

    private var placeholderLastName = Text(String(String(l10n.CaregiverCreation.caregiverPlaceholderLastName.characters)))

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
                AvatarPicker(selectedAvatar: self.newCaregiver.avatar,
                             onSelect: { avatar in
                                 self.newCaregiver.avatar = avatar
                             })
                             .navigationBarTitleDisplayMode(.inline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - l10n.CaregiverCreation

// swiftlint:disable line_length

extension l10n {
    enum CaregiverCreation {
        static let title = LocalizedString("lekaapp.caregiver_creation.title", value: "Create a caregiver profile", comment: "Caregiver creation title")

        static let avatarChoiceButton = LocalizedString("lekaapp.caregiver_creation.avatar_choice_button", value: "Choose an avatar", comment: "Caregiver creation avatar choice button label")

        static let caregiverFirstNameLabel = LocalizedString("lekaapp.caregiver_creation.caregiver_first_name_label", value: "First name", comment: "Caregiver creation caregiver first name textfield label")

        static let caregiverPlaceholderFirstName = LocalizedString("lekaapp.caregiver_creation.caregiver_placeholder_first_name", value: "required", comment: "Caregiver creation caregiver placeholder first name textfield")

        static let caregiverLastNameLabel = LocalizedString("lekaapp.caregiver_creation.caregiver_last_name_label", value: "Last name", comment: "Caregiver creation caregiver last name textfield label")

        static let caregiverPlaceholderLastName = LocalizedString("lekaapp.caregiver_creation.caregiver_placeholder_last_name", value: "optional", comment: "Caregiver creation caregiver placeholder last name textfield")

        static let professionLabel = LocalizedString("lekaapp.caregiver_creation.profession_label", value: "Profession(s)", comment: "Caregiver creation profession label above profession selection button")

        static let createProfileButtonLabel = LocalizedString("lekaapp.caregiver_creation.create_profile_button_label", value: "Create profile", comment: "Caregiver creation create profile button label")

        static let closeButtonLabel = LocalizedString("lekaapp.caregiver_creation.close_button_label", value: "Close", comment: "Caregiver creation close button label")
    }
}

// swiftlint:enable line_length

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                CreateCaregiverView()
            }
        }
}
