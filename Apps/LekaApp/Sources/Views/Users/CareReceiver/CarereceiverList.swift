// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CarereceiverList

struct CarereceiverList: View {
    // MARK: Internal

    var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: "figure.2.arms.open")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(self.styleManager.accentColor!)

                    VStack(alignment: .leading) {
                        Text(l10n.CarereceiverList.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text(l10n.CarereceiverList.subtitle)
                            .font(.title2)

                        Text(l10n.CarereceiverList.description)
                            .foregroundStyle(.secondary)

                        Divider()
                            .padding(.top)
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding()

                if self.carereceiverManagerViewModel.carereceivers.isEmpty {
                    VStack {
                        Text(l10n.CarereceiverList.CreateFirstCarereceiver.message)
                            .font(.title2)
                            .multilineTextAlignment(.center)

                        Button {
                            self.isCarereceiverCreationPresented = true
                        } label: {
                            Text(l10n.CarereceiverList.CreateFirstCarereceiver.createButtonLabel)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, 150)
                } else {
                    LazyVGrid(columns: self.columns) {
                        ForEach(self.carereceiverManagerViewModel.carereceivers) { carereceiver in
                            NavigationLink(value: carereceiver) {
                                CarereceiverAvatarCell(carereceiver: carereceiver)
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.isCarereceiverCreationPresented = true
                    } label: {
                        Text(l10n.CarereceiverList.createButtonLabel)
                    }
                }
            }
            .sheet(isPresented: self.$isCarereceiverCreationPresented) {
                NavigationStack {
                    CreateCarereceiverView()
                        .logEventScreenView(screenName: "carereceiver_create", context: .sheet)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .navigationDestination(for: Carereceiver.self) { carereceiver in
                CarereceiverView(carereceiver: carereceiver)
            }
        }
    }

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 4)
    private var styleManager: StyleManager = .shared

    @State private var carereceiverManagerViewModel = CarereceiverManagerViewModel()
    @State private var isCarereceiverCreationPresented: Bool = false
}

// MARK: - l10n.CarereceiverList

// swiftlint:disable line_length nesting

extension l10n {
    enum CarereceiverList {
        enum CreateFirstCarereceiver {
            static let message = LocalizedString("lekaapp.carereceiver_list.create_first_carereceiver.message",
                                                 value: "No care receiver profiles have been created yet.",
                                                 comment: "Carereceiver list create first carereceiver message")

            static let createButtonLabel = LocalizedString("lekaapp.carereceiver_list.create_first_carereceiver.create_button_label",
                                                           value: "Create your first care receiver profile",
                                                           comment: "Carereceiver list create first carereceiver button label")
        }

        static let title = LocalizedString("lekaapp.carereceiver_list.title",
                                           value: "Care receivers",
                                           comment: "Carereceiver list title")

        static let subtitle = LocalizedString("lekaapp.carereceiver_list.subtitle",
                                              value: "Detailed tracking and management of care receiver profiles.",
                                              comment: "Carereceiver list subtitle")

        static let description = LocalizedString("lekaapp.carereceiver_list.description",
                                                 value: "Edit care receiver profiles, track their progress, and access activity history for tailored support and engagement.",
                                                 comment: "Carereceiver list description")

        static let createButtonLabel = LocalizedString("lekaapp.carereceiver_list.create_button_label",
                                                       value: "Create profile",
                                                       comment: "Carereceiver list create button label")
    }
}

// swiftlint:enable line_length nesting

#Preview {
    CarereceiverList()
}
