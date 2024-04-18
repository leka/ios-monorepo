// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - DragAndDropToSortView

struct DragAndDropToSortView: View {
    @State var items: [MovableItemData]
    @Binding var numberOfColumns: Int
    @State var draggingItem: MovableItemData?

    var body: some View {
        let columns = Array(repeating: GridItem(spacing: 10), count: numberOfColumns)
        LazyVGrid(columns: columns, spacing: 40, content: {
            ForEach(self.items, id: \.id) { item in
                MovableItem(data: item)
                    .onDrag {
                        self.draggingItem = item
                        return NSItemProvider()
                    }
                    .onDrop(of: [.text], delegate: DropViewDelegate(
                        destinationItem: item,
                        itemCollection: self.$items,
                        draggedItem: self.$draggingItem,
                        isDragged: .constant(self.draggingItem == item)
                    ))
            }
        })
        .padding(15)
        .frame(maxWidth: self.numberOfColumns == 2 ? 600 : .infinity)
        .animation(.easeInOut(duration: 0.5), value: self.numberOfColumns)
    }
}

// MARK: - DropViewDelegate

struct DropViewDelegate: DropDelegate {
    // MARK: Internal

    let destinationItem: MovableItemData
    @Binding var itemCollection: [MovableItemData]
    @Binding var draggedItem: MovableItemData?
    @Binding var isDragged: Bool

    func dropEntered(info _: DropInfo) {
        self.swapItems()
    }

    func dropUpdated(info _: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info _: DropInfo) -> Bool {
        self.draggedItem = nil
        return true
    }

    // MARK: Private

    private func swapItems() {
        if let draggedItem {
            let fromIndex = self.itemCollection.firstIndex(of: draggedItem)
            let animation = Animation.interactiveSpring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.25)
            if let fromIndex {
                guard let toIndex = itemCollection.firstIndex(of: destinationItem) else {
                    return
                }
                if fromIndex != toIndex {
                    withAnimation(animation) {
                        self.itemCollection
                            .move(
                                fromOffsets: IndexSet(integer: fromIndex),
                                toOffset: toIndex > fromIndex ? (toIndex + 1) : toIndex
                            )
                    }
                } else {
                    withAnimation(animation) {
                        self.itemCollection
                            .move(
                                fromOffsets: IndexSet(integer: fromIndex),
                                toOffset: toIndex
                            )
                    }
                }
            }
        }
    }
}
