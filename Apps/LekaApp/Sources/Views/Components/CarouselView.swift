// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import ContentKit
import SwiftUI

// MARK: - CarouselView

public struct CarouselView: View {
    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(self.items.prefix(8)) { item in
                    NavigationLink(destination:
                        AnyView(self.navigation.curationDestination(item))
                    ) {
                        CarouselItem(item)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        AnalyticsManager.logEventSelectContent(
                            type: self.getAnalyticsContentType(for: item.contentType),
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

    private func getAnalyticsContentType(for type: ContentType) -> AnalyticsManager.ContentType {
        switch type {
            case .curation:
                .curation
            case .curriculum:
                .curriculum
            case .activity:
                .activity
            case .story:
                .story
        }
    }
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!

    return CarouselView(
        items: sandboxCuration.sections[0].items
    )
}
