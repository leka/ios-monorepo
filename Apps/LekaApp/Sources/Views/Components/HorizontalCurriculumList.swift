// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - HorizontalCurriculumList

public struct HorizontalCurriculumList: View {
    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(self.items.prefix(8)) { item in
                    NavigationLink(destination:
                        AnyView(self.navigation.curationDestination(item.curation))
                    ) {
                        CurriculumItem(item.curation)
                    }
                }
            }
            .padding()
        }
    }

    // MARK: Internal

    let items: [ContentCategory.CurationPayload]

    // MARK: Private

    @State private var navigation: Navigation = .shared
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!

    ScrollView {
        HorizontalCurriculumList(
            items: sandboxCuration.sections[1].items
        )
    }
}
