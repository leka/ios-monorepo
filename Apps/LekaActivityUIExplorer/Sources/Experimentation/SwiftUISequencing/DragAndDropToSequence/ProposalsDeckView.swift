// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ProposalsDeckView: View {
    let title: String
    @Binding var cards: [CardItem]
    let isTargeted: Bool

    @State var draggingItem: CardItem?

    var body: some View {
        VStack(alignment: .center) {
            Text(self.title).font(.footnote.bold())

            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(self.isTargeted ? .teal.opacity(0.35) : Color(.secondarySystemFill))

                let columns = Array(repeating: GridItem(spacing: 10), count: 5)
                LazyVGrid(columns: columns, spacing: 12, content: {
                    ForEach(self.cards, id: \.id) { task in
                        DraggableTile(item: task)
                            .padding(12)
                            .draggable(task) {
                                DraggableTile(item: task)
                                    .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 14,
                                                                                 style: .continuous))
                                    .onAppear {
                                        self.draggingItem = task
                                    }
                            }
                            .dropDestination(for: CardItem.self) { _, _ in
                                self.draggingItem = nil
                                return false
                            } isTargeted: { status in
                                if let draggingItem, status, draggingItem != task {
                                    // Moving Color from source to destination
                                    if let sourceIndex = cards.firstIndex(of: draggingItem),
                                       let destinationIndex = cards.firstIndex(of: task)
                                    {
                                        withAnimation(.default) {
                                            let sourceItem = self.cards.remove(at: sourceIndex)
                                            self.cards.insert(sourceItem, at: destinationIndex)
                                        }
                                    }
                                }
                            }
                    }
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 244)
        .padding()
    }
}
