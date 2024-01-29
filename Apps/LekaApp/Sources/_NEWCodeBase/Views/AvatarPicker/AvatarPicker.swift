// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

struct AvatarPicker: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ListView(selected: self.$selected)
            .onAppear {
                self.selected = self.avatar
            }
            .navigationTitle(String(l10n.AvatarPicker.title.characters))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.avatar = self.selected
                        self.dismiss()
                    } label: {
                        Label(String(l10n.AvatarPicker.validateButton.characters), systemImage: "checkmark.circle")
                    }
                    .disabled(self.selected.isEmpty)
                }
            }
    }

    // MARK: Private

    @State private var selected: String = ""
    @Binding var avatar: String
}

#Preview {
    NavigationStack {
        AvatarPicker(avatar: .constant(DesignKitAsset.Avatars.accompanyingBlue.name))
    }
}
