// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

struct AvatarPicker: View {
    // MARK: Lifecycle

    init(selectedAvatar: String, onCancel: (() -> Void)? = nil, onValidate: ((String) -> Void)? = nil) {
        self.onCancel = onCancel
        self.onValidate = onValidate
        self._selectedAvatar = State(wrappedValue: selectedAvatar)
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    @State var selectedAvatar: String = ""
    let onCancel: (() -> Void)?
    let onValidate: ((String) -> Void)?

    var body: some View {
        ListView(selectedAvatar: self.$selectedAvatar)
            .navigationTitle(String(l10n.AvatarPicker.title.characters))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.action = .cancel
                        self.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.action = .validate
                        self.dismiss()
                    } label: {
                        Label(String(l10n.AvatarPicker.validateButton.characters), systemImage: "checkmark.circle")
                    }
                    .disabled(self.selectedAvatar.isEmpty)
                }
            }
            .onDisappear {
                switch self.action {
                    case .cancel:
                        self.onCancel?()
                    case .validate:
                        self.onValidate?(self.selectedAvatar)
                    case .none:
                        break
                }

                self.action = nil
            }
    }

    // MARK: Private

    private enum ActionType {
        case cancel
        case validate
    }

    @State private var action: ActionType?
}

#Preview {
    NavigationStack {
        AvatarPicker(
            selectedAvatar: Avatars.categories[0].avatars[0],
            onCancel: {
                print("Avatar choice canceled")
            },
            onValidate: {
                print("You chose \($0)")
            }
        )
    }
}
