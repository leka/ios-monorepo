// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - VerticalCurationGrid

public struct VerticalCurationGrid: View {
    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns, spacing: 10) {
            ForEach(self.items) { item in
                NavigationLink(destination:
                    AnyView(self.navigation.curationDestination(item.curation))
                ) {
                    CurationItem(item.curation)
                }
            }
        }
        .padding()
    }

    // MARK: Internal

    let items: [ContentCategory.CurationPayload]

    // MARK: Private

    @State private var navigation: Navigation = .shared

    private let columns = [
        GridItem(.adaptive(minimum: 220), spacing: 20),
    ]
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!

    ScrollView {
        VerticalCurationGrid(
            items: sandboxCuration.sections[5].items
        )
    }
}
