// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - HorizontalCurationList

public struct HorizontalCurationList: View {
    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(self.items.prefix(8)) { item in
                    NavigationLink(destination:
                        AnyView(self.navigation.curationDestination(item))
                    ) {
                        CurationItem(item)
                    }
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
        HorizontalCurationList(
            items: sandboxCuration.sections[5].items
        )
    }
}
