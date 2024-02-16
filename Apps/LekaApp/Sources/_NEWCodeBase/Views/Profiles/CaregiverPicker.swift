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

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: self.columns, spacing: 40) {
                        ForEach(self.rootOwnerViewModel.mockCaregiversSet) { caregiver in
                            Button {
                                // TODO: (@team) - Add caregiver selection logic w/ Firebase
                                self.styleManager.colorScheme = caregiver.preferredColorScheme
                                self.styleManager.accentColor = caregiver.preferredAccentColor
                                self.authManagerViewModel.isUserLoggedOut = false
                                self.rootOwnerViewModel.currentCaregiver = caregiver
                            } label: {
                                CaregiverAvatarCell(caregiver: caregiver)
                                    .frame(maxWidth: 140)
                            }
                        }

                        // ? Last item is Add profile button
                        self.addCaregiverButton
                    }
                    .padding()
                }
            }
            .padding(.horizontal, 50)
            .navigationTitle(String(l10n.CaregiverPicker.title.characters))
            .sheet(isPresented: self.$isCaregiverCreationPresented) {
                CreateCaregiverView(isPresented: self.$isCaregiverCreationPresented) {}
            }
        }
    }

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 4)

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @State private var selected: String = ""
    @State private var isCaregiverCreationPresented: Bool = false

    private var addCaregiverButton: some View {
        Button {
            self.isCaregiverCreationPresented = true
        } label: {
            VStack(spacing: 10) {
                Circle()
                    .fill(Color(uiColor: .systemGray4))
                    .frame(maxWidth: 140)
                    .overlay {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .foregroundStyle(.gray)
                    }

                Text(l10n.CaregiverPicker.addButtonLabel)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - l10n.CaregiverPicker

extension l10n {
    enum CaregiverPicker {
        static let title = LocalizedString("lekaapp.caregiver_picker.title", value: "Who are you ?", comment: "Caregiver picker title")

        static let addButtonLabel = LocalizedString("lekaapp.caregiver_picker.addButtonLabel", value: "Add profile", comment: "Caregiver picker add button label")
    }
}

#Preview {
    NavigationStack {
        CaregiverPicker()
    }
}
