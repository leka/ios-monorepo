// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CarereceiverPicker

struct CarereceiverPicker: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    var action: () -> Void

    var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                LazyVGrid(columns: self.columns, spacing: 40) {
                    ForEach(self.rootOwnerViewModel.mockCarereceiversSet) { carereceiver in
                        CarereceiverAvatarCell(carereceiver: carereceiver, isSelected: .constant(self.selected == carereceiver))
                            .onTapGesture {
                                withAnimation(.default) {
                                    if self.selected == carereceiver {
                                        self.selected = nil
                                    } else {
                                        self.selected = carereceiver
                                    }
                                }
                            }
                    }
                }
                .padding()
            }
            .navigationTitle(String(l10n.CarereceiverPicker.title.characters))
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text(l10n.CarereceiverPicker.closeButtonLabel)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.rootOwnerViewModel.currentCarereceiver = self.selected
                        self.action()
                    } label: {
                        Text(l10n.CarereceiverPicker.validateButtonLabel)
                    }
                    .disabled(self.selected == nil)
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        self.action()
                    } label: {
                        Text(l10n.CarereceiverPicker.skipButtonLabel)
                            .font(.footnote)
                    }
                    Spacer()
                }
            }
        }
    }

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 4)

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @State private var selected: Carereceiver?
}

// MARK: - l10n.CarereceiverPicker

extension l10n {
    enum CarereceiverPicker {
        static let title = LocalizedString("lekaapp.carereceiver_picker.title",
                                           value: "Who do you do this activity with?",
                                           comment: "Carereceiver picker title")

        static let validateButtonLabel = LocalizedString("lekaapp.carereceiver_picker.validate_button_label",
                                                         value: "Validate",
                                                         comment: "Carereceiver picker validate button label")

        static let skipButtonLabel = LocalizedString("lekaapp.carereceiver_picker.skip_button_label",
                                                     value: "Continue without profile",
                                                     comment: "Carereceiver picker continue without profile button label")

        static let closeButtonLabel = LocalizedString("lekaapp.carereceiver_picker.close_button_label",
                                                      value: "Close",
                                                      comment: "Carereceiver picker close button label")
    }
}

#Preview {
    NavigationStack {
        CarereceiverPicker {
            print("action")
        }
    }
}
