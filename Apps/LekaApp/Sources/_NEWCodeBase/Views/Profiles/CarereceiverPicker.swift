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
        NavigationStack {
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
                .padding()
            }
            .navigationTitle(String(l10n.CarereceiverPicker.title.characters))
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
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
                        Text(l10n.CarereceiverPicker.validateButtonLabel)
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

    @State private var selectedCarereceiver: Carereceiver?
    @State private var action: ActionType?
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
