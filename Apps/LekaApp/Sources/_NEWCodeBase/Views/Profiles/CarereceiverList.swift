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

                LazyVGrid(columns: self.columns, spacing: 40) {
                    ForEach(self.carereceiverManagerViewModel.carereceivers) { carereceiver in
                        NavigationLink(value: carereceiver) {
                            CarereceiverAvatarCell(carereceiver: carereceiver)
                        }
                    }
                }
            }
            .navigationTitle(String(l10n.CarereceiverList.title.characters))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.isCarereceiverCreationPresented = true
                    } label: {
                        Text(l10n.CarereceiverList.addButtonLabel)
                    }
                }
            }
            .sheet(isPresented: self.$isCarereceiverCreationPresented) {
                CreateCarereceiverView(isPresented: self.$isCarereceiverCreationPresented) {}
            }
            .navigationDestination(for: Carereceiver.self) { carereceiver in
                CarereceiverView(carereceiver: carereceiver)
            }
        }
    }

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 4)

    @ObservedObject private var carereceiverManagerViewModel = CarereceiverManagerViewModel.shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @State private var selected: String = ""
    @State private var isCarereceiverCreationPresented: Bool = false
}

// MARK: - l10n.CarereceiverList

extension l10n {
    enum CarereceiverList {
        static let title = LocalizedString("lekaapp.carereceiver_list.title",
                                           value: "Care receivers",
                                           comment: "Carereceiver list title")

        static let subtitle = LocalizedString("lekaapp.carereceiver_list.subtitle",
                                              value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                              comment: "Carereceiver list subtitle")

        static let description = LocalizedString("lekaapp.carereceiver_list.description",
                                                 value: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                                                 comment: "Carereceiver list description")

        static let addButtonLabel = LocalizedString("lekaapp.carereceiver_list.add_button_label",
                                                    value: "Add profile",
                                                    comment: "Carereceiver list add button label")
    }
}

#Preview {
    CarereceiverList()
}
