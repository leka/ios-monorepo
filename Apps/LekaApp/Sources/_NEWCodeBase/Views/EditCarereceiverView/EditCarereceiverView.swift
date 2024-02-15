// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - EditCarereceiverView

struct EditCarereceiverView: View {
    // MARK: Internal

    @Binding var modifiedCarereceiver: Carereceiver

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
                            TextField("", text: self.$modifiedCarereceiver.name)
                                .multilineTextAlignment(.trailing)
                        }
                    }

                    Section {
                        LabeledContent(String(l10n.ReinforcerPicker.header.characters)) {
                            ReinforcerPicker(carereceiver: self.$modifiedCarereceiver)
                        }
                    } footer: {
                        Text(l10n.ReinforcerPicker.description)
                    }
                }
            }
            .navigationTitle(String(l10n.EditCarereceiverView.navigationTitle.characters))
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(String(l10n.EditCarereceiverView.closeButtonLabel.characters)) {
                        self.rootOwnerViewModel.isEditCarereceiverViewPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(l10n.EditCarereceiverView.saveButtonLabel.characters)) {
                        // TODO: (@mathieu) - Add Firestore logic
                        self.rootOwnerViewModel.isEditCarereceiverViewPresented = false
                        self.rootOwnerViewModel.currentCarereceiver = self.modifiedCarereceiver
                    }
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @State private var isAvatarPickerPresented: Bool = false

    private var avatarPickerButton: some View {
        Button {
            self.isAvatarPickerPresented = true
        } label: {
            VStack(alignment: .center, spacing: 15) {
                AvatarPicker.ButtonLabel(image: self.modifiedCarereceiver.avatar)
                Text(l10n.CarereceiverCreation.avatarChoiceButton)
                    .font(.headline)
            }
        }
        .navigationDestination(isPresented: self.$isAvatarPickerPresented) {
            AvatarPicker(avatar: self.$modifiedCarereceiver.avatar)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    EditCarereceiverView(modifiedCarereceiver: .constant(Carereceiver()))
}
