// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CarereceiverSettingsView

struct CarereceiverSettingsView: View {
    // MARK: Internal

    @Binding var modifiedCarereceiver: Carereceiver

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Form {
                    self.avatarPickerButton
                        .listRowBackground(Color.clear)

                    Section {
                        LabeledContent(String(l10n.CarereceiverCreation.carereceiverNameLabel.characters)) {
                            TextField("Nom", text: self.$modifiedCarereceiver.name)
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
            .navigationTitle(String(l10n.CarereceiverSettingsView.navigationTitle.characters) + self.modifiedCarereceiver.name)
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(String(l10n.CarereceiverSettingsView.closeButtonLabel.characters)) {
                        self.rootOwnerViewModel.isCarereceiverSettingsViewPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(l10n.CarereceiverSettingsView.saveButtonLabel.characters)) {
                        // TODO: (@mathieu) - Add Firestore logic
                        self.rootOwnerViewModel.isCarereceiverSettingsViewPresented = false
                        self.rootOwnerViewModel.currentCarereceiver = self.modifiedCarereceiver
                    }
                }
            }
        }
        .preferredColorScheme(self.styleManager.colorScheme)
    }

    // MARK: Private

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared
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
    CarereceiverSettingsView(modifiedCarereceiver: .constant(Carereceiver()))
}
