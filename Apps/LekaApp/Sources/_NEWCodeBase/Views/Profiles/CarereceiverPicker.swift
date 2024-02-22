// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CarereceiverPicker

struct CarereceiverPicker: View {
    // MARK: Internal

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    Label(String(l10n.CarereceiverPicker.subtitle.characters), systemImage: "figure.2.arms.open")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    Text(l10n.CarereceiverPicker.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    LazyVGrid(columns: self.columns, spacing: 40) {
                        ForEach(self.rootOwnerViewModel.mockCarereceiversSet) { carereceiver in
                            NavigationLink(value: carereceiver) {
                                CarereceiverAvatarCell(carereceiver: carereceiver)
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding()
            .navigationTitle(String(l10n.CarereceiverPicker.title.characters))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.isCarereceiverCreationPresented = true
                    } label: {
                        Text(l10n.CarereceiverPicker.addButtonLabel)
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

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared

    @State private var selected: String = ""
    @State private var isCarereceiverCreationPresented: Bool = false
}

// MARK: - l10n.CarereceiverPicker

extension l10n {
    enum CarereceiverPicker {
        static let title = LocalizedString("lekaapp.carereceiver_picker.title",
                                           value: "Care receivers",
                                           comment: "Carereceiver picker title")

        static let subtitle = LocalizedString("lekaapp.carereceiver_picker.subtitle",
                                              value: "These are the care receivers profiles accompanied by professionals during sessions.",
                                              comment: "Carereceiver picker subtitle")

        static let description = LocalizedString("lekaapp.carereceiver_picker.description",
                                                 value: "Each profile is individual. It displays data specific to each care receiver using Leka app.",
                                                 comment: "Carereceiver picker description")

        static let addButtonLabel = LocalizedString("lekaapp.carereceiver_picker.addButtonLabel",
                                                    value: "Add profile",
                                                    comment: "Carereceiver picker add button label")
    }
}

#Preview {
    CarereceiverPicker()
}
