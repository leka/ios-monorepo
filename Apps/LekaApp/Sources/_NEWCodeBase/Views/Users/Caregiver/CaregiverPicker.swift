// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CaregiverPicker

struct CaregiverPicker: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            if self.caregiverManagerViewModel.caregivers.isEmpty {
                self.noCaregiverView
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: self.columns, spacing: 40) {
                        ForEach(self.caregiverManagerViewModel.caregivers, id: \.id) { caregiver in
                            CaregiverAvatarCell(caregiver: caregiver, isSelected: self.selectedCaregiver?.id == caregiver.id)
                                .frame(maxWidth: 125)
                                .onTapGesture {
                                    withAnimation(.default) {
                                        if self.selectedCaregiver?.id == caregiver.id {
                                            self.selectedCaregiver = nil
                                        } else {
                                            self.selectedCaregiver = caregiver
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle(String(l10n.CaregiverPicker.title.characters))
        .interactiveDismissDisabled(self.caregiverManagerViewModel.currentCaregiver == nil)
        .sheet(isPresented: self.$isCaregiverCreationPresented) {
            NavigationStack {
                CreateCaregiverView()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .toolbar {
            if self.caregiverManagerViewModel.currentCaregiver != nil {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text(l10n.CaregiverPicker.closeButtonLabel)
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.styleManager.colorScheme = self.selectedCaregiver!.colorScheme
                    self.styleManager.accentColor = self.selectedCaregiver!.colorTheme.color
                    self.caregiverManager.setCurrentCaregiver(to: self.selectedCaregiver!)
                    self.dismiss()
                } label: {
                    Text(l10n.CaregiverPicker.selectButtonLabel)
                }
                .disabled(self.selectedCaregiver == nil)
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    self.isCaregiverCreationPresented = true
                } label: {
                    Text(l10n.CaregiverPicker.addButtonLabel)
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    @State private var selectedCaregiver: Caregiver?
    @State private var isCaregiverCreationPresented: Bool = false

    private var caregiverManager: CaregiverManager = .shared
    private let columns = Array(repeating: GridItem(), count: 4)

    private var noCaregiverView: some View {
        VStack {
            Text(l10n.CaregiverPicker.AddFirstCaregiver.message)
                .font(.title2)
                .multilineTextAlignment(.center)

            Button {
                self.isCaregiverCreationPresented = true
            } label: {
                Text(l10n.CaregiverPicker.AddFirstCaregiver.buttonLabel)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - l10n.CaregiverPicker

extension l10n {
    // swiftlint:disable line_length nesting
    enum CaregiverPicker {
        enum AddFirstCaregiver {
            static let message = LocalizedString("lekaapp.caregiver_picker.add_first_caregiver.message",
                                                 value: "No caregiver profiles have been created yet.",
                                                 comment: "Caregiver picker add first caregiver message")

            static let buttonLabel = LocalizedString("lekaapp.caregiver_picker.add_first_caregiver.add_button_label",
                                                     value: "Add your first caregiver profile",
                                                     comment: "Caregiver picker add first caregiver button label")
        }

        static let title = LocalizedString("lekaapp.caregiver_picker.title", value: "Who are you ?", comment: "Caregiver picker title")

        static let selectButtonLabel = LocalizedString("lekaapp.caregiver_picker.select_button_label", value: "Select", comment: "Caregiver picker select button label")

        static let addButtonLabel = LocalizedString("lekaapp.caregiver_picker.add_button_label", value: "Add profile", comment: "Caregiver picker add button label")

        static let closeButtonLabel = LocalizedString("lekaapp.caregiver_picker.close_button_label", value: "Close", comment: "Caregiver picker close button label")
    }
    // swiftlint:enable line_length nesting
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                CaregiverPicker()
            }
        }
}
