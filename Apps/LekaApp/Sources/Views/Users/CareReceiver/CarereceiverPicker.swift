// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CarereceiverPicker

struct CarereceiverPicker: View {
    // MARK: Lifecycle

    init(selected: Carereceiver? = nil, onDismiss: (() -> Void)? = nil, onSelected: ((Carereceiver) -> Void)? = nil, onSkip: (() -> Void)? = nil) {
        self.selectedCarereceiver = selected
        self.onDismiss = onDismiss
        self.onSelected = onSelected
        self.onSkip = onSkip
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var onDismiss: (() -> Void)?
    var onSelected: ((Carereceiver) -> Void)?
    var onSkip: (() -> Void)?

    var body: some View {
        VStack {
            switch self.carereceiverManagerViewModel.carereceivers.count {
                case 0:
                    self.noCarereceiverView
                case 1...4:
                    self.oneToFourCarereceiversView
                default:
                    self.fiveOrMoreCarereceiversView
            }
        }
        .navigationTitle(String(l10n.CarereceiverPicker.title.characters))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.action = .dismiss
                    self.dismiss()
                } label: {
                    Text(l10n.CarereceiverPicker.closeButtonLabel)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.action = .select
                    self.dismiss()
                } label: {
                    Text(l10n.CarereceiverPicker.selectButtonLabel)
                }
                .disabled(self.selectedCarereceiver == nil)
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    self.action = .skip
                    self.dismiss()
                } label: {
                    Text(l10n.CarereceiverPicker.skipButtonLabel)
                        .font(.footnote)
                }
                Spacer()
            }
        }
        .onDisappear {
            switch self.action {
                case .dismiss:
                    self.onDismiss?()
                case .select:
                    if let selectedCarereceiver = self.selectedCarereceiver {
                        self.onSelected?(selectedCarereceiver)
                    }
                case .skip:
                    self.onSkip?()
                case .none:
                    break
            }

            self.action = nil
        }
    }

    // MARK: Private

    private enum ActionType {
        case dismiss
        case select
        case skip
    }

    private let columns = Array(repeating: GridItem(), count: 4)

    @StateObject private var carereceiverManagerViewModel = CarereceiverManagerViewModel()
    @ObservedObject private var navigation: Navigation = .shared
    @State private var selectedCarereceiver: Carereceiver?
    @State private var action: ActionType?

    private var noCarereceiverView: some View {
        VStack {
            Text(l10n.CarereceiverPicker.CreateFirstCarereceiver.message)
                .font(.title2)
                .multilineTextAlignment(.center)

            Button {
                self.dismiss()
                self.navigation.selectedCategory = .carereceivers
            } label: {
                Text(l10n.CarereceiverPicker.CreateFirstCarereceiver.buttonLabel)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var oneToFourCarereceiversView: some View {
        HStack(spacing: 40) {
            ForEach(self.carereceiverManagerViewModel.carereceivers, id: \.id) { carereceiver in
                CarereceiverAvatarCell(carereceiver: carereceiver, isSelected: self.selectedCarereceiver?.id == carereceiver.id)
                    .frame(maxWidth: 125)
                    .onTapGesture {
                        withAnimation(.default) {
                            if self.selectedCarereceiver?.id == carereceiver.id {
                                self.selectedCarereceiver = nil
                            } else {
                                self.selectedCarereceiver = carereceiver
                            }
                        }
                    }
            }
        }
    }

    private var fiveOrMoreCarereceiversView: some View {
        ScrollView(showsIndicators: true) {
            LazyVGrid(columns: self.columns, spacing: 40) {
                ForEach(self.carereceiverManagerViewModel.carereceivers) { carereceiver in
                    CarereceiverAvatarCell(carereceiver: carereceiver, isSelected: self.selectedCarereceiver == carereceiver)
                        .onTapGesture {
                            withAnimation(.default) {
                                if self.selectedCarereceiver == carereceiver {
                                    self.selectedCarereceiver = nil
                                } else {
                                    self.selectedCarereceiver = carereceiver
                                }
                            }
                        }
                }
            }
        }
    }
}

// MARK: - l10n.CarereceiverPicker

extension l10n {
    // swiftlint:disable nesting
    enum CarereceiverPicker {
        enum CreateFirstCarereceiver {
            static let message = LocalizedString("lekaapp.carereceiver_picker.create_first_carereceiver.message",
                                                 value: """
                                                     No care receiver profiles have been created yet.
                                                     You can create one in the Care Receivers section.
                                                     """,
                                                 comment: "Carereceiver picker create first carereceiver message")

            static let buttonLabel = LocalizedString("lekaapp.carereceiver_picker.create_first_carereceiver.button_label",
                                                     value: "Go to Care Receivers section",
                                                     comment: "Carereceiver picker button label that send to the Care Receivers section")
        }

        static let title = LocalizedString("lekaapp.carereceiver_picker.title",
                                           value: "Who do you do this activity with?",
                                           comment: "Carereceiver picker title")

        static let selectButtonLabel = LocalizedString("lekaapp.carereceiver_picker.select_button_label",
                                                       value: "Select",
                                                       comment: "Carereceiver picker select button label")

        static let skipButtonLabel = LocalizedString("lekaapp.carereceiver_picker.skip_button_label",
                                                     value: "Continue without profile",
                                                     comment: "Carereceiver picker continue without profile button label")

        static let closeButtonLabel = LocalizedString("lekaapp.carereceiver_picker.close_button_label",
                                                      value: "Close",
                                                      comment: "Carereceiver picker close button label")
    }
    // swiftlint:enable nesting
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                CarereceiverPicker(onDismiss: {
                    print("dismiss")
                }, onSelected: {
                    print("selected carereceiver: \($0)")
                },
                onSkip: {
                    print("skip")
                })
            }
        }
}
