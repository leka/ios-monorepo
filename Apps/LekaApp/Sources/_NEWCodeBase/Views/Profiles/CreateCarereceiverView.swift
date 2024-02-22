// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CreateCarereceiverView

struct CreateCarereceiverView: View {
    // MARK: Internal

    @Binding var isPresented: Bool
    @State private var newCarereceiver = Carereceiver_OLD()
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
                        LabeledContent(String(l10n.CarereceiverCreation.carereceiverNameLabel.characters)) {
                            TextField("", text: self.$newCarereceiver.name)
                                .multilineTextAlignment(.trailing)
                        }
                    }

                    Button(String(l10n.CarereceiverCreation.registerProfilButton.characters)) {
                        withAnimation {
                            self.isPresented.toggle()
                            self.onDismissAction()
                        }
                        if self.newCarereceiver.avatar.isEmpty {
                            self.newCarereceiver.avatar = AvatarSets.sunglasses.content.images.randomElement()!
                        }
                        // TODO: (@team) : add the carereceiver profile to the account
                        // TODO: (@team) : assign the carereceiver profile as the current selected one
                        self.rootOwnerViewModel.mockCarereceiversSet.append(self.newCarereceiver)
                    }
                    .disabled(self.newCarereceiver.name.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle(String(l10n.CarereceiverCreation.title.characters))
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
                AvatarPicker.ButtonLabel(image: self.newCarereceiver.avatar)
                Text(l10n.CarereceiverCreation.avatarChoiceButton)
                    .font(.headline)
            }
        }
        .navigationDestination(isPresented: self.$isAvatarPickerPresented) {
            AvatarPicker(avatar: self.$newCarereceiver.avatar)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - l10n.CarereceiverCreation

// swiftlint:disable line_length

extension l10n {
    enum CarereceiverCreation {
        static let title = LocalizedString("lekaapp.carereceiver_creation.title", value: "Create a carereceiver profile", comment: " Carereceiver creation title")

        static let avatarChoiceButton = LocalizedString("lekaapp.carereceiver_creation.avatar_choice_button", value: "Choose an avatar", comment: " Carereceiver creation avatar choice button label")

        static let carereceiverNameLabel = LocalizedString("lekaapp.carereceiver_creation.carereceiver_name_label", value: "Username", comment: " Carereceiver creation carereceiver name textfield label")

        static let registerProfilButton = LocalizedString("lekaapp.carereceiver_creation.register_profil_button", value: "Register profile", comment: " Carereceiver creation register profil button label")
    }
}

// swiftlint:enable line_length

#Preview {
    CreateCarereceiverView(isPresented: .constant(true)) {
        print("Carereceiver saved")
    }
}
