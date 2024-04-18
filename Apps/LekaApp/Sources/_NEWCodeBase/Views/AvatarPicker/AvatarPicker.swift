// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

struct AvatarPicker: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ListView(selectedAvatar: self.$selectedAvatar)
            .onAppear {
                self.selectedAvatar = self.avatar
            }
            .navigationTitle(String(l10n.AvatarPicker.title.characters))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.avatar = self.selectedAvatar
                        self.dismiss()
                    } label: {
                        Label(String(l10n.AvatarPicker.validateButton.characters), systemImage: "checkmark.circle")
                    }
                    .disabled(self.selectedAvatar.isEmpty)
                }
            }
    }

    // MARK: Private

    @State private var selectedAvatar: String = ""
    @Binding var avatar: String
}

#Preview {
    NavigationStack {
        AvatarPicker(avatar: .constant(Avatars.categories[0].avatars[0]))
    }
}
