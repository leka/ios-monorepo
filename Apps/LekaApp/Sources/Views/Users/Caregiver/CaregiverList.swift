// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CaregiverList

struct CaregiverList: View {
    // MARK: Internal

    var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(self.styleManager.accentColor!)

                    VStack(alignment: .leading) {
                        Text(l10n.CaregiverList.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text(l10n.CaregiverList.subtitle)
                            .font(.title2)

                        Text(l10n.CaregiverList.description)
                            .foregroundStyle(.secondary)

                        Divider()
                            .padding(.top)
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding()

                if self.caregiverManagerViewModel.caregivers.isEmpty {
                    VStack {
                        Text(l10n.CaregiverList.CreateFirstCaregiver.message)
                            .font(.title2)
                            .multilineTextAlignment(.center)

                        Button {
                            self.isCaregiverCreationPresented = true
                        } label: {
                            Text(l10n.CaregiverList.CreateFirstCaregiver.createButtonLabel)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, 150)
                } else {
                    LazyVGrid(columns: self.columns) {
                        ForEach(self.caregiverManagerViewModel.caregivers) { caregiver in
                            NavigationLink(value: caregiver) {
                                CaregiverAvatarCell(caregiver: caregiver)
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.isCaregiverCreationPresented = true
                    } label: {
                        Text(l10n.CaregiverList.createButtonLabel)
                    }
                }
            }
            .sheet(isPresented: self.$isCaregiverCreationPresented) {
                NavigationStack {
                    CreateCaregiverView()
                        .logEventScreenView(screenName: "caregiver_create", context: .sheet)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .navigationDestination(for: Caregiver.self) { caregiver in
                CaregiverView(caregiver: caregiver)
            }
        }
    }

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 4)
    private var styleManager: StyleManager = .shared

    @State private var isCaregiverCreationPresented: Bool = false
    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()
}

// MARK: - l10n.CaregiverList

// swiftlint:disable line_length nesting

extension l10n {
    enum CaregiverList {
        enum CreateFirstCaregiver {
            static let message = LocalizedString("lekaapp.caregiver_list.create_first_caregiver.message",
                                                 value: "No caregiver profiles have been created yet.",
                                                 comment: "Caregiver list create first caregiver message")

            static let createButtonLabel = LocalizedString("lekaapp.caregiver_list.create_first_caregiver.create_button_label",
                                                           value: "Create your first caregiver profile",
                                                           comment: "Caregiver list create first caregiver button label")
        }

        static let title = LocalizedString("lekaapp.caregiver_list.title",
                                           value: "Caregivers",
                                           comment: "Caregiver list title")

        static let subtitle = LocalizedString("lekaapp.caregiver_list.subtitle",
                                              value: "Manage profiles and track caregiver activities.",
                                              comment: "Caregiver list subtitle")

        static let description = LocalizedString("lekaapp.caregiver_list.description",
                                                 value: "Access and modify the profiles of professionals and caregivers, view statistics and usage history.",
                                                 comment: "Caregiver list description")

        static let createButtonLabel = LocalizedString("lekaapp.caregiver_list.create_button_label",
                                                       value: "Create profile",
                                                       comment: "Caregiver list create button label")
    }
}

// swiftlint:enable line_length nesting

#Preview {
    CaregiverList()
}
