// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - VerticalActivityGrid

public struct VerticalActivityGrid: View {
    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns, spacing: 30) {
            ForEach(self.items) { item in
                NavigationLink(destination:
                    AnyView(self.navigation.curationDestination(item))
                ) {
                    ActivityItem(item)
                }
            }
        }
        .padding()
    }

    // MARK: Internal

    let items: [CurationItemModel]

    // MARK: Private

    @State private var navigation: Navigation = .shared

    private let columns = [
        GridItem(.adaptive(minimum: 180), spacing: 30),
    ]
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!

    ScrollView {
        VerticalActivityGrid(
            items: sandboxCuration.sections[2].items
        )
    }
}
