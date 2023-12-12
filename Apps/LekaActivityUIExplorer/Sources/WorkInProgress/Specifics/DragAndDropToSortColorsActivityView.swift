// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

let rainbowColors: [MovableItemData] = [
    MovableItemData(color: .purple),
    MovableItemData(color: .blue),
    MovableItemData(color: .mint),
    MovableItemData(color: .green),
    MovableItemData(color: .yellow),
    MovableItemData(color: .orange),
    MovableItemData(color: .red),
    MovableItemData(color: .pink),
].shuffled()

// MARK: - DragAndDropToSortColorsActivityView

struct DragAndDropToSortColorsActivityView: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.secondary, lineWidth: 2)
                    .padding(10)
                DragAndDropToSortView(items: rainbowColors, numberOfColumns: .constant(self.isGridOn ? 4 : 8))
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
