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
            Group {
                if self.caregiverManagerViewModel.caregivers.isEmpty {
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
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: self.columns, spacing: 40) {
                            ForEach(self.caregiverManagerViewModel.caregivers, id: \.id) { caregiver in
                                Button {
                                    self.styleManager.colorScheme = caregiver.colorScheme
                                    self.styleManager.accentColor = caregiver.colorTheme.color
                                    self.caregiverManager.setCurrentCaregiver(to: caregiver)
                                    self.dismiss()
                                } label: {
                                    CaregiverAvatarCell(caregiver: caregiver)
                                        .frame(maxWidth: 140)
                                }
                                .disabled(self.caregiverManagerViewModel.isListLoading)
                            }
                        }
                    }
                    .padding()
                }
            }
            .loadingIndicator(isLoading: self.caregiverManagerViewModel.isListLoading)
        }
        .padding(.horizontal, 50)
        .navigationTitle(String(l10n.CaregiverPicker.title.characters))
        .sheet(isPresented: self.$isCaregiverCreationPresented) {
            NavigationStack {
                CreateCaregiverView()
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
                    self.isCaregiverCreationPresented = true
                } label: {
                    Text(l10n.CaregiverPicker.addButtonLabel)
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    @State private var selected: String = ""
    @State private var isCaregiverCreationPresented: Bool = false

    private var caregiverManager: CaregiverManager = .shared
    private let columns = Array(repeating: GridItem(), count: 4)
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
