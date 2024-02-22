// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

extension AvatarPicker {
    struct ListView: View {
        // MARK: Internal

        @Binding var selectedAvatar: String

        var body: some View {
            List {
                ForEach(Avatars.categories, id: \.self) { category in
                    Section(category.name) {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: self.rows, spacing: 50) {
                                ForEach(category.avatars, id: \.self) { icon in
                                    Button {
                                        self.selectedAvatar = icon
                                    } label: {
                                        AvatarCellLabel(
                                            image: Avatars.iconToUIImage(icon: icon),
                                            isSelected: .constant(self.selectedAvatar == icon)
                                        )
                                    }
                                    .animation(.easeIn, value: self.selectedAvatar)
                                }
                            }
                            .padding()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .listRowInsets(EdgeInsets())
            }
        }

        // MARK: Private

        private let rows = [GridItem()]
    }
}

#Preview {
    AvatarPicker.ListView(selectedAvatar: .constant(""))
}
