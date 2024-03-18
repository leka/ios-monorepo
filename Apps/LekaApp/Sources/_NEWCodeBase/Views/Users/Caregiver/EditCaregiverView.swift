// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - EditCaregiverView

struct EditCaregiverView: View {
    // MARK: Lifecycle

    init(caregiver: Caregiver) {
        self._viewModel = StateObject(wrappedValue: EditCaregiverViewViewModel(caregiver: caregiver))
    }

    // MARK: Internal

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
                        TextField("", text: self.$viewModel.caregiver.firstName)
                            .textContentType(.givenName)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.secondary)
                    }
                    LabeledContent(String(l10n.CaregiverCreation.caregiverLastNameLabel.characters)) {
                        TextField("", text: self.$viewModel.caregiver.lastName)
                            .textContentType(.familyName)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.secondary)
                    }
                }

                Section {
                    ProfessionListView(caregiver: self.$viewModel.caregiver)
                        .navigationBarTitleDisplayMode(.inline)
                }

                Section {
                    AppearanceRow(caregiver: self.$viewModel.caregiver)
                    AccentColorRow(caregiver: self.$viewModel.caregiver)
                }
            }
        }
        .navigationTitle(String(l10n.EditCaregiverView.navigationTitle.characters))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(String(l10n.EditCaregiverView.closeButtonLabel.characters)) {
                    self.styleManager.colorScheme = self.caregiverManagerViewModel.currentCaregiver!.colorScheme
                    self.styleManager.accentColor = self.caregiverManagerViewModel.currentCaregiver!.colorTheme.color
                    self.dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(l10n.EditCaregiverView.saveButtonLabel.characters)) {
                    self.caregiverManager.updateCaregiver(caregiver: &self.viewModel.caregiver)
                    self.dismiss()
                }
            }
        }
        .preferredColorScheme(self.styleManager.colorScheme)
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    private var caregiverManager: CaregiverManager = .shared

    @StateObject private var viewModel: EditCaregiverViewViewModel
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    @ObservedObject private var styleManager: StyleManager = .shared

    private var avatarPickerButton: some View {
        Button {
            self.viewModel.isAvatarPickerPresented = true
        } label: {
            VStack(alignment: .center, spacing: 15) {
                AvatarPicker.ButtonLabel(image: self.viewModel.caregiver.avatar)
                Text(l10n.CaregiverCreation.avatarChoiceButton)
                    .font(.headline)
            }
        }
        .sheet(isPresented: self.$viewModel.isAvatarPickerPresented) {
            NavigationStack {
                AvatarPicker(selectedAvatar: self.viewModel.caregiver.avatar,
                             onValidate: { avatar in
                                 self.viewModel.caregiver.avatar = avatar
                             })
                             .navigationBarTitleDisplayMode(.inline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - EditCaregiverViewViewModel

class EditCaregiverViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(caregiver: Caregiver) {
        self.caregiver = caregiver
    }

    // MARK: Internal

    @Published var caregiver: Caregiver
    @Published var isAvatarPickerPresented: Bool = false
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                EditCaregiverView(caregiver: Caregiver())
            }
        }
}
