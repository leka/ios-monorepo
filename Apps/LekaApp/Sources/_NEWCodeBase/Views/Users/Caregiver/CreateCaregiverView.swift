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

    init(onCancel: (() -> Void)? = nil, onCreated: ((Caregiver) -> Void)? = nil) {
        self.onCancel = onCancel
        self.onCreated = onCreated
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    var onCancel: (() -> Void)?
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
                        .navigationBarTitleDisplayMode(.inline)
                }

                Button {
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
                } label: {
                    Text(String(l10n.CaregiverCreation.registerProfilButton.characters))
                        .loadingIndicator(isLoading: self.caregiverManagerViewModel.isCreateLoading)
                }
                .disabled(self.newCaregiver.firstName.isEmpty || self.caregiverManagerViewModel.isCreateLoading)
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(String(l10n.CaregiverCreation.title.characters))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.action = .cancel
                    self.dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }
        }
        .onDisappear {
            switch self.action {
                case .cancel:
                    self.onCancel?()
                case .created:
                    self.onCreated?(self.newCaregiver)
                case .none:
                    break
            }

            self.action = nil
        }
    }

    // MARK: Private

    private enum ActionType {
        case cancel
        case created
    }

    @StateObject private var viewModel = CreateCaregiverViewModel()
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

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
                             onValidate: { avatar in
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

        static let professionAddButton = LocalizedString("lekaapp.caregiver_creation.profession_add_button", value: "Add", comment: "Caregiver creation profession add button label")

        static let registerProfilButton = LocalizedString("lekaapp.caregiver_creation.register_profil_button", value: "Register profile", comment: "Caregiver creation register profil button label")
    }
}

// swiftlint:enable line_length

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                CreateCaregiverView(onCancel: { print("Creation canceled") },
                                    onCreated: { print("Caregiver \($0.firstName) created") })
            }
        }
}
