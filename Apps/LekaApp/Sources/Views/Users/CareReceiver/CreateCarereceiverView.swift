// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CreateCarereceiverViewModel

@Observable
class CreateCarereceiverViewModel {
    // MARK: Internal

    var carereceiverManager: CarereceiverManager = .shared

    // MARK: - Public functions

    func createCarereceiver(carereceiver: Carereceiver, onError: @escaping (Error) -> Void) {
        self.carereceiverManager.createCarereceiver(carereceiver: carereceiver)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        print("Carereceiver Creation successful.")
                    case let .failure(error):
                        print("Carereceiver Creation failed with error: \(error)")
                        onError(error)
                }
            }, receiveValue: { _ in
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - CreateCarereceiverView

struct CreateCarereceiverView: View {
    // MARK: Lifecycle

    init(onClose: (() -> Void)? = nil) {
        self.onClose = onClose
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var onClose: (() -> Void)?

    var carereceiverManager: CarereceiverManager = .shared

    var body: some View {
        VStack(spacing: 40) {
            Form {
                Section {
                    self.avatarPickerButton
                        .buttonStyle(.borderless)
                        .listRowBackground(Color.clear)
                }

                Section {
                    LabeledContent(String(l10n.CarereceiverCreation.carereceiverNameLabel.characters)) {
                        TextField("", text: self.$newCarereceiver.username, prompt: self.placeholderName)
                            .textContentType(.username)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.secondary)
                            .focused(self.$focused)
                            .onChange(of: self.focused) {
                                if !self.focused {
                                    self.newCarereceiver.username = self.newCarereceiver.username.trimLeadingAndTrailingWhitespaces()
                                }
                            }
                    }
                }

                Section {
                    LabeledContent(String(l10n.ReinforcerPicker.header.characters)) {
                        ReinforcerPicker(carereceiver: self.$newCarereceiver)
                    }
                } footer: {
                    Text(l10n.ReinforcerPicker.description)
                }

                Button(String(l10n.CarereceiverCreation.createProfileButtonLabel.characters)) {
                    if self.newCarereceiver.avatar.isEmpty {
                        self.newCarereceiver.avatar = Avatars.categories.first!.avatars.randomElement()!
                    }
                    self.viewModel.createCarereceiver(carereceiver: self.newCarereceiver, onError: { error in
                        print(error.localizedDescription)
                    })
                    self.isCarereceiverCreated = true
                    withAnimation {
                        self.dismiss()
                    }
                }
                .disabled(self.newCarereceiver.username.isEmpty)
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(String(l10n.CarereceiverCreation.title.characters))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.dismiss()
                } label: {
                    Text(l10n.CarereceiverCreation.closeButtonLabel)
                }
            }
        }
        .onDisappear {
            if self.isCarereceiverCreated {
                self.onClose?()
            }
        }
    }

    // MARK: Private

    @State private var isCarereceiverCreated: Bool = false
    @State private var viewModel = CreateCarereceiverViewModel()

    @FocusState private var focused: Bool

    @State private var newCarereceiver = Carereceiver()
    @State private var isAvatarPickerPresented: Bool = false

    private var placeholderName = Text(String(String(l10n.CarereceiverCreation.carereceiverPlaceholderName.characters)))

    private var avatarPickerButton: some View {
        Button {
            self.isAvatarPickerPresented = true
        } label: {
            VStack(alignment: .center, spacing: 15) {
                AvatarPicker.ButtonLabel(image: self.newCarereceiver.avatar)
                Text(l10n.CarereceiverCreation.avatarChoiceButton)
                    .font(.headline)
            }
        }
        .sheet(isPresented: self.$isAvatarPickerPresented) {
            NavigationStack {
                AvatarPicker(selectedAvatar: self.newCarereceiver.avatar,
                             onSelect: { avatar in
                                 self.newCarereceiver.avatar = avatar
                             })
                             .navigationBarTitleDisplayMode(.inline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - l10n.CarereceiverCreation

// swiftlint:disable line_length

extension l10n {
    enum CarereceiverCreation {
        static let title = LocalizedString("lekaapp.carereceiver_creation.title", value: "Create a carereceiver profile", comment: "Carereceiver creation title")

        static let avatarChoiceButton = LocalizedString("lekaapp.carereceiver_creation.avatar_choice_button", value: "Choose an avatar", comment: "Carereceiver creation avatar choice button label")

        static let carereceiverNameLabel = LocalizedString("lekaapp.carereceiver_creation.carereceiver_name_label", value: "Username", comment: "Carereceiver creation carereceiver name textfield label")

        static let carereceiverPlaceholderName = LocalizedString("lekaapp.carereceiver_creation.carereceiver_placeholder_name", value: "required", comment: "Carereceiver creation carereceiver placeholder name textfield")

        static let createProfileButtonLabel = LocalizedString("lekaapp.carereceiver_creation.create_profile_button_label", value: "Create profile", comment: "Carereceiver creation create profile button label")

        static let closeButtonLabel = LocalizedString("lekaapp.carereceiver_creation.close_button_label", value: "Close", comment: "Carereceiver creation close button label")
    }
}

// swiftlint:enable line_length

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                CreateCarereceiverView(onClose: {
                    print("Care receiver creation canceled")
                })
            }
        }
}
