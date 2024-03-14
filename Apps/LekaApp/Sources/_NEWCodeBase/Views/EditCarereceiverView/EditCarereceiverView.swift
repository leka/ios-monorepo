// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - EditCarereceiverView

struct EditCarereceiverView: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    @Binding var modifiedCarereceiver: Carereceiver

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
                        TextField("", text: self.$modifiedCarereceiver.username)
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(String(l10n.EditCarereceiverView.closeButtonLabel.characters)) {
                    self.dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(l10n.EditCarereceiverView.saveButtonLabel.characters)) {
                    self.carereceiverManager.updateCarereceiver(carereceiver: &self.modifiedCarereceiver)
                    self.dismiss()
                }
            }
        }
    }

    // MARK: Private

    @State private var isAvatarPickerPresented: Bool = false
    var carereceiverManager: CarereceiverManager = .shared

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
        .sheet(isPresented: self.$isAvatarPickerPresented) {
            NavigationStack {
                AvatarPicker(selectedAvatar: self.modifiedCarereceiver.avatar,
                             onValidate: { avatar in
                                 self.modifiedCarereceiver.avatar = avatar
                             })
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                EditCarereceiverView(modifiedCarereceiver: .constant(Carereceiver()))
            }
        }
}
