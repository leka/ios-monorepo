// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - VerticalCurriculumGrid

public struct VerticalCurriculumGrid: View {
    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns, spacing: 30) {
            ForEach(self.items) { item in
                NavigationLink(destination:
                    AnyView(self.navigation.curationDestination(item.curation))
                ) {
                    CurriculumItem(item.curation)
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
        GridItem(.adaptive(minimum: 180), spacing: 20),
    ]
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!

    ScrollView {
        VerticalCurriculumGrid(
            items: sandboxCuration.sections[1].items
        )
    }
}
