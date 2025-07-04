// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import ContentKit
import SwiftUI

// MARK: - HorizontalActivityGrid

public struct HorizontalActivityGrid: View {
    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: self.rows, spacing: 20) {
                ForEach(Array(self.items.prefix(15).enumerated()), id: \.offset) { index, item in
                    NavigationLink(destination:
                        AnyView(self.navigation.curationDestination(item))
                    ) {
                        VStack {
                            ActivityGridItem(item)
                            let isNotLast = (index + 1) % self.numberOfRows != 0
                            if isNotLast {
                                Divider()
                                    .padding(.leading, 90)
                            }
                        }
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        AnalyticsManager.logEventSelectContent(
                            type: item.contentType == .activity ? .activity : .story,
                            id: item.id,
                            name: item.name,
                            origin: self.navigation.selectedCategory?.rawValue
                        )
                    })
                }
            }
            .padding()
        }
    }

    // MARK: Internal

    let items: [CurationItemModel]

    // MARK: Private

    @State private var navigation: Navigation = .shared

    private var numberOfRows: Int {
        switch self.items.count {
            case 0..<4: 1
            case 4..<7: 2
            default: 3
        }
    }

    private var rows: [GridItem] {
        Array(repeating: GridItem(spacing: 20), count: self.numberOfRows)
    }
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!

    ScrollView {
        HorizontalActivityGrid(
            items: sandboxCuration.sections[2].items
        )
    }
}
