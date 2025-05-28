// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import ContentKit
import SwiftUI

// MARK: - HorizontalActivityList

public struct HorizontalActivityList: View {
    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(self.items.prefix(8)) { item in
                    NavigationLink(destination:
                        AnyView(self.navigation.curationDestination(item))
                    ) {
                        ActivityItem(item)
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
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!

    ScrollView {
        HorizontalActivityList(
            items: sandboxCuration.sections[2].items
        )
    }
}
