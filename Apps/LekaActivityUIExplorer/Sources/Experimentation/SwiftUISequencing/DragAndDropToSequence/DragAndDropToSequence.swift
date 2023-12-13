// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - DragAndDropToSequence

struct DragAndDropToSequence: View {
    // MARK: Internal

    var body: some View {
        VStack {
            Spacer()
            ProposalsDeckView(title: "Proposals", cards: self.$proposals, isTargeted: self.isProposalsTargeted)
                .dropDestination(for: CardItem.self) { droppedItems, _ in
                    for task in droppedItems {
                        self.card1Items.removeAll(where: { $0.id == task.id })
                        self.card2Items.removeAll(where: { $0.id == task.id })
                        self.card3Items.removeAll(where: { $0.id == task.id })
                        self.card4Items.removeAll(where: { $0.id == task.id })
                        self.card5Items.removeAll(where: { $0.id == task.id })
                    }
                    let index = self.proposals.firstIndex(where: { $0.title == "" })
                    guard let index else {
                        return false
                    }
                    self.copyAt(index: index, droppedItem: droppedItems[0])
                    return true
                } isTargeted: { isTargeted in
                    self.isProposalsTargeted = isTargeted
                }
            Spacer()
            HStack(spacing: 20) {
                DestinationSlotView(title: "Step #1", cards: self.$card1Items, isTargeted: self.isSlot1Targeted)
                    .dropDestination(for: CardItem.self) { droppedItems, _ in
                        guard self.card1Items.isEmpty else {
                            return false
                        }
                        for task in droppedItems {
                            self.card2Items.removeAll(where: { $0.id == task.id })
                            self.card3Items.removeAll(where: { $0.id == task.id })
                            self.card4Items.removeAll(where: { $0.id == task.id })
                            self.card5Items.removeAll(where: { $0.id == task.id })
                            guard !self.proposals.contains(where: { $0.id == task.id }) else {
                                let index = self.proposals.firstIndex(where: { $0.id == task.id })
                                self.proposals[index!] = CardItem(id: UUID(), title: "", color: "clear")
                                break
                            }
                        }
                        self.copyTo(destination: &self.card1Items, droppedItems: droppedItems)
                        return true
                    } isTargeted: { isTargeted in
                        self.isSlot1Targeted = self.card1Items.isEmpty ? isTargeted : false
                    }
                DestinationSlotView(title: "Step #2", cards: self.$card2Items, isTargeted: self.isSlot2Targeted)
                    .dropDestination(for: CardItem.self) { droppedItems, _ in
                        guard self.card2Items.isEmpty else {
                            return false
                        }
                        for task in droppedItems {
                            self.card1Items.removeAll(where: { $0.id == task.id })
                            self.card3Items.removeAll(where: { $0.id == task.id })
                            self.card4Items.removeAll(where: { $0.id == task.id })
                            self.card5Items.removeAll(where: { $0.id == task.id })
                            guard !self.proposals.contains(where: { $0.id == task.id }) else {
                                let index = self.proposals.firstIndex(where: { $0.id == task.id })
                                self.proposals[index!] = CardItem(id: UUID(), title: "", color: "clear")
                                break
                            }
                        }
                        self.copyTo(destination: &self.card2Items, droppedItems: droppedItems)
                        return true
                    } isTargeted: { isTargeted in
                        self.isSlot2Targeted = self.card2Items.isEmpty ? isTargeted : false
                    }
                DestinationSlotView(title: "Step #3", cards: self.$card3Items, isTargeted: self.isSlot3Targeted)
                    .dropDestination(for: CardItem.self) { droppedItems, _ in
                        guard self.card3Items.isEmpty else {
                            return false
                        }
                        for task in droppedItems {
                            self.card1Items.removeAll(where: { $0.id == task.id })
                            self.card2Items.removeAll(where: { $0.id == task.id })
                            self.card4Items.removeAll(where: { $0.id == task.id })
                            self.card5Items.removeAll(where: { $0.id == task.id })
                            guard !self.proposals.contains(where: { $0.id == task.id }) else {
                                let index = self.proposals.firstIndex(where: { $0.id == task.id })
                                self.proposals[index!] = CardItem(id: UUID(), title: "", color: "clear")
                                break
                            }
                        }
                        self.copyTo(destination: &self.card3Items, droppedItems: droppedItems)
                        return true
                    } isTargeted: { isTargeted in
                        self.isSlot3Targeted = self.card3Items.isEmpty ? isTargeted : false
                    }
                DestinationSlotView(title: "Step #4", cards: self.$card4Items, isTargeted: self.isSlot4Targeted)
                    .dropDestination(for: CardItem.self) { droppedItems, _ in
                        guard self.card4Items.isEmpty else {
                            return false
                        }
                        for task in droppedItems {
                            self.card1Items.removeAll(where: { $0.id == task.id })
                            self.card2Items.removeAll(where: { $0.id == task.id })
                            self.card3Items.removeAll(where: { $0.id == task.id })
                            self.card5Items.removeAll(where: { $0.id == task.id })
                            guard !self.proposals.contains(where: { $0.id == task.id }) else {
                                let index = self.proposals.firstIndex(where: { $0.id == task.id })
                                self.proposals[index!] = CardItem(id: UUID(), title: "", color: "clear")
                                break
                            }
                        }
                        self.copyTo(destination: &self.card4Items, droppedItems: droppedItems)
                        return true
                    } isTargeted: { isTargeted in
                        self.isSlot4Targeted = self.card4Items.isEmpty ? isTargeted : false
                    }
                DestinationSlotView(title: "Step #5", cards: self.$card5Items, isTargeted: self.isSlot5Targeted)
                    .dropDestination(for: CardItem.self) { droppedItems, _ in
                        guard self.card5Items.isEmpty else {
                            return false
                        }
                        for task in droppedItems {
                            self.card1Items.removeAll(where: { $0.id == task.id })
                            self.card2Items.removeAll(where: { $0.id == task.id })
                            self.card3Items.removeAll(where: { $0.id == task.id })
                            self.card4Items.removeAll(where: { $0.id == task.id })
                            guard !self.proposals.contains(where: { $0.id == task.id }) else {
                                let index = self.proposals.firstIndex(where: { $0.id == task.id })
                                self.proposals[index!] = CardItem(id: UUID(), title: "", color: "clear")
                                break
                            }
                        }
                        self.copyTo(destination: &self.card5Items, droppedItems: droppedItems)
                        return true
                    } isTargeted: { isTargeted in
                        self.isSlot5Targeted = self.card5Items.isEmpty ? isTargeted : false
                    }
            }
            .padding()
        }
    }

    // MARK: Private

    @State private var proposals: [CardItem] = [
        MockData.card1,
        MockData.card2,
        MockData.card3,
        MockData.card4,
        MockData.card5,
    ].shuffled()
    @State private var card1Items: [CardItem] = []
    @State private var card2Items: [CardItem] = []
    @State private var card3Items: [CardItem] = []
    @State private var card4Items: [CardItem] = []
    @State private var card5Items: [CardItem] = []

    @State private var isProposalsTargeted: Bool = false
    @State private var isSlot1Targeted: Bool = false
    @State private var isSlot2Targeted: Bool = false
    @State private var isSlot3Targeted: Bool = false
    @State private var isSlot4Targeted: Bool = false
    @State private var isSlot5Targeted: Bool = false

    private func copyTo(destination: inout [CardItem], droppedItems: [CardItem]) {
        // add a copy of the original item & make sure there is no duplicates
        let joined = destination + droppedItems
        let totalTasks: Set<CardItem> = Set(joined)
        destination = Array(totalTasks)
    }

    private func copyAt(index: Int, droppedItem: CardItem) {
        guard !self.proposals.contains(where: { $0.id == droppedItem.id }) else {
            return
        }
        self.proposals[index] = droppedItem
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropToSequence()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
