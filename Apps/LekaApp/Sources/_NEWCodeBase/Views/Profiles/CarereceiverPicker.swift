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
                    LazyVGrid(columns: self.columns, spacing: 40) {
                        ForEach(self.rootOwnerViewModel.mockCarereceiversSet) { carereceiver in
                            Button {
                                // TODO: (@team) - Add carereceiver selection logic w/ Firebase
                                self.rootOwnerViewModel.currentCarereceiver = carereceiver
                                self.rootOwnerViewModel.isCarereceiverPickerViewPresented = false
                            } label: {
                                CarereceiverAvatarCell(carereceiver: carereceiver)
                            }
                        }

                        // ? Last item is Add profile button
                        self.addCarereceiverButton
                    }
                    .padding()
                }
            }
            .padding()
            .navigationTitle(String(l10n.CarereceiverPicker.title.characters))
            .sheet(isPresented: self.$isCarereceiverCreationPresented) {
                CreateCarereceiverView(isPresented: self.$isCarereceiverCreationPresented) {}
            }
        }
    }

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 4)

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared

    @State private var selected: String = ""
    @State private var isCarereceiverCreationPresented: Bool = false

    private var addCarereceiverButton: some View {
        Button {
            self.isCarereceiverCreationPresented = true
        } label: {
            VStack(spacing: 10) {
                Circle()
                    .fill(Color(uiColor: .systemGray4))
                    .frame(maxWidth: 120)
                    .overlay {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .foregroundStyle(.gray)
                    }

                Text(l10n.CarereceiverPicker.addButtonLabel)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - l10n.CarereceiverPicker

extension l10n {
    enum CarereceiverPicker {
        static let title = LocalizedString("lekaapp.carereceiver_picker.title",
                                           value: "Care receivers list",
                                           comment: "Carereceiver picker title")

        static let addButtonLabel = LocalizedString("lekaapp.carereceiver_picker.addButtonLabel",
                                                    value: "Add profile",
                                                    comment: "Carereceiver picker add button label")
    }
}

#Preview {
    CarereceiverPicker()
}
