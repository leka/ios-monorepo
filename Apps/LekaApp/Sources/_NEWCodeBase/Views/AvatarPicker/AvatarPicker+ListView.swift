// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension AvatarPicker {
    struct ListView: View {
        // MARK: Internal

        @Binding var selected: String

        var body: some View {
            List {
                ForEach(AvatarSets.allCases, id: \.id) { category in
                    Section(category.content.category) {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: self.rows, spacing: 50) {
                                ForEach(category.content.images, id: \.self) { item in
                                    Button {
                                        self.selected = item
                                    } label: {
                                        AvatarCellLabel(
                                            image: item,
                                            isSelected: .constant(self.selected == item)
                                        )
                                    }
                                    .animation(.easeIn, value: self.selected)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                        .frame(height: 180)
                    }
                }
            }
        }

        // MARK: Private

        private let rows = [GridItem()]
    }
}

#Preview {
    AvatarPicker.ListView(selected: .constant(""))
}
