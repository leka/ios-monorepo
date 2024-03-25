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

    func createCaregiver(caregiver: Caregiver, onCreated: @escaping (Caregiver) -> Void, onError: @escaping (Error) -> Void) {
        self.caregiverManager.createCaregiver(caregiver: caregiver)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        print("Caregiver Creation successful.")
                    case let .failure(error):
                        print("Caregiver Creation failed with error: \(error)")
                        onError(error)
                }
            }, receiveValue: { createdCaregiver in
                onCreated(createdCaregiver)
            })
            .store(in: &self.cancellables)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - CreateCaregiverView

struct CreateCaregiverView: View {
    // MARK: Lifecycle

    init(onClose: (() -> Void)? = nil, onCreated: ((Caregiver) -> Void)? = nil) {
        self.onClose = onClose
        self.onCreated = onCreated
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    var onClose: (() -> Void)?
    var onCreated: ((Caregiver) -> Void)?

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
                        TextField("", text: self.$newCaregiver.firstName)
                            .textContentType(.givenName)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.secondary)
                    }
                    LabeledContent(String(l10n.CaregiverCreation.caregiverLastNameLabel.characters)) {
                        TextField("", text: self.$newCaregiver.lastName)
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
                    self.viewModel.createCaregiver(caregiver: self.newCaregiver, onCreated: { createdCaregiver in
                        self.newCaregiver = createdCaregiver
                        withAnimation {
                            self.action = .created
                            self.dismiss()
                        }
                    }, onError: { error in
                        // Handle error
                        print(error.localizedDescription)
                    })
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
                    self.action = .close
                    self.dismiss()
                } label: {
                    Text(l10n.CarereceiverCreation.closeButtonLabel)
                }
            }
        }
        .onDisappear {
            switch self.action {
                case .close:
                    self.onClose?()
                case .created:
                    // TODO: (@dev/team remove) tmp fix, remove on created in a future commit
                    self.onClose?()
                case .none:
                    break
            }

            self.action = nil
        }
    }

    // MARK: Private

    private enum ActionType {
        case close
        case created
    }

    @StateObject private var viewModel = CreateCaregiverViewModel()

    @State private var newCaregiver = Caregiver()
    @State private var isAvatarPickerPresented: Bool = false
    @State private var action: ActionType?
    @State private var cancellables = Set<AnyCancellable>()

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

        static let caregiverLastNameLabel = LocalizedString("lekaapp.caregiver_creation.caregiver_last_name_label", value: "Last name", comment: "Caregiver creation caregiver last name textfield label")

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
                CreateCaregiverView(onClose: { print("Creation canceled") },
                                    onCreated: { print("Caregiver \($0.firstName) created") })
            }
        }
}
