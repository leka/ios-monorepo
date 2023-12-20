// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

let fruits: [MovableItemData] = [
    MovableItemData(color: .clear, image: Image("banana")),
    MovableItemData(color: .clear, image: Image("avocado")),
    MovableItemData(color: .clear, image: Image("cherry")),
    MovableItemData(color: .clear, image: Image("watermelon")),
].shuffled()

// MARK: - DragAndDropToSortImagesActivityView

struct DragAndDropToSortImagesActivityView: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.secondary, lineWidth: 1)
                    .padding(10)
                DragAndDropToSortView(items: fruits, numberOfColumns: .constant(self.isGridOn ? 2 : 4))
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Toggle(isOn: self.$isGridOn) {
                        Image(systemName: "rectangle.grid.3x2")
                            .symbolVariant(self.isGridOn ? .fill : .none)
                    }
                    .tint(.accentColor)
                    .padding(20)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        self.dismiss()
                    }
                }
            }
        }
    }

    // MARK: Private

    @State private var isGridOn: Bool = false
}
