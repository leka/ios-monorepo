// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - DraggableTile

struct DraggableTile: View {
    // MARK: Internal

    let item: CardItem

    var body: some View {
        self.makeTile(item: self.item)
    }

    // MARK: Private

    @ViewBuilder
    private func makeTile(item: CardItem) -> some View {
        Text(item.title)
            .frame(width: 150, height: 220)
            .background(Color(item.color),
                        in: RoundedRectangle(cornerRadius: 14,
                                             style: .continuous))
            .shadow(radius: 1, x: 1, y: 1)
    }
}

// MARK: - DraggableTile_Previews

struct DraggableTile_Previews: PreviewProvider {
    static var previews: some View {
        DraggableTile(item: CardItem(id: UUID(), title: "Card #", color: "lekaGreen"))
    }
}
