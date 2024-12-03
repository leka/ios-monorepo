// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

struct AvatarPicker: View {
    // MARK: Lifecycle

    init(selectedAvatar: String, onCancel: (() -> Void)? = nil, onSelect: ((String) -> Void)? = nil) {
        self.onCancel = onCancel
        self.onSelect = onSelect
        self._selectedAvatar = State(wrappedValue: selectedAvatar)
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    @State var selectedAvatar: String = ""

    let onCancel: (() -> Void)?
    let onSelect: ((String) -> Void)?

    var body: some View {
        ListView(selectedAvatar: self.$selectedAvatar)
            .navigationTitle(String(l10n.AvatarPicker.title.characters))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.action = .cancel
                        self.dismiss()
                    } label: {
                        Text(l10n.AvatarPicker.closeButtonLabel)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.action = .select
                        self.dismiss()
                    } label: {
                        Text(l10n.AvatarPicker.selectButtonLabel)
                    }
                    .disabled(self.selectedAvatar.isEmpty)
                }
            }
            .onDisappear {
                switch self.action {
                    case .cancel:
                        self.onCancel?()
                    case .select:
                        self.onSelect?(self.selectedAvatar)
                    case .none:
                        break
                }

                self.action = nil
            }
    }

    // MARK: Private

    private enum ActionType {
        case cancel
        case select
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
            onSelect: {
                print("You chose \($0)")
            }
        )
    }
}
