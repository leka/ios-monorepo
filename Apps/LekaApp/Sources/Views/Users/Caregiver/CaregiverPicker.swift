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
                switch self.caregiverManagerViewModel.caregivers.count {
                    case 0:
                        self.noCaregiverView
                    case 1...4:
                        self.oneToFourCaregiversView
                    default:
                        self.fiveOrMoreCaregiversView
                }
            }
            .loadingIndicator(isLoading: self.caregiverManagerViewModel.isLoading)
        }
        .padding(.horizontal)
        .navigationTitle(String(l10n.CaregiverPicker.title.characters))
        .interactiveDismissDisabled(self.isCurrentCaregiverUnknown)
        .sheet(isPresented: self.$isCaregiverCreationPresented) {
            NavigationStack {
                CreateCaregiverView()
                    .logEventScreenView(screenName: "caregiver_create", context: .sheet)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .toolbar {
            if !self.isCurrentCaregiverUnknown {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text(l10n.CaregiverPicker.closeButtonLabel)
                    }
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    self.isCaregiverCreationPresented = true
                } label: {
                    Label(String(l10n.CaregiverPicker.createButtonLabel.characters), systemImage: "person.badge.plus")
                        .labelStyle(.titleAndIcon)
                        .font(.footnote)
                }
                .buttonStyle(.bordered)
                .tint(nil)
            }
        }
    }

    // MARK: Private

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    @State private var isCaregiverCreationPresented: Bool = false

    private var caregiverManager: CaregiverManager = .shared
    private let columns = Array(repeating: GridItem(), count: 4)

    private var isCurrentCaregiverUnknown: Bool {
        self.caregiverManagerViewModel.currentCaregiver == nil
    }

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

    private var oneToFourCaregiversView: some View {
        HStack(spacing: 40) {
            ForEach(self.caregiverManagerViewModel.caregivers, id: \.id) { caregiver in
                Button {
                    self.caregiverManager.setCurrentCaregiver(to: caregiver)
                    self.dismiss()
                } label: {
                    CaregiverAvatarCell(caregiver: caregiver)
                        .frame(maxWidth: 125)
                        .disabled(self.caregiverManagerViewModel.isLoading)
                }
            }
        }
    }

    private var fiveOrMoreCaregiversView: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: self.columns, spacing: 40) {
                ForEach(self.caregiverManagerViewModel.caregivers, id: \.id) { caregiver in
                    Button {
                        self.caregiverManager.setCurrentCaregiver(to: caregiver)
                        self.dismiss()
                    } label: {
                        CaregiverAvatarCell(caregiver: caregiver)
                            .frame(maxWidth: 125)
                            .disabled(self.caregiverManagerViewModel.isLoading)
                    }
                }
            }
        }
    }
}

// MARK: - l10n.CaregiverPicker

// swiftlint:disable line_length nesting

extension l10n {
    enum CaregiverPicker {
        enum AddFirstCaregiver {
            static let message = LocalizedString("lekaapp.caregiver_picker.add_first_caregiver.message",
                                                 value: "No caregiver profiles have been created yet.",
                                                 comment: "Caregiver picker add first caregiver message")

            static let buttonLabel = LocalizedString("lekaapp.caregiver_picker.add_first_caregiver.add_button_label",
                                                     value: "Add your first caregiver profile",
                                                     comment: "Caregiver picker add first caregiver button label")
        }

        static let title = LocalizedString("lekaapp.caregiver_picker.title", value: "Select your profile", comment: "Caregiver picker title")

        static let createButtonLabel = LocalizedString("lekaapp.caregiver_picker.create_button_label", value: "Create profile", comment: "Caregiver picker create button label")

        static let closeButtonLabel = LocalizedString("lekaapp.caregiver_picker.close_button_label", value: "Close", comment: "Caregiver picker close button label")
    }
}

// swiftlint:enable line_length nesting

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                CaregiverPicker()
            }
        }
}
