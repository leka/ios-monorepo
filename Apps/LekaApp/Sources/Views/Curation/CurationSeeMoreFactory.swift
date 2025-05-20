// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

// MARK: - CurationSeeMoreFactory

public struct CurationSeeMoreFactory: View {
    // MARK: Lifecycle

    // MARK: Public

    public var body: some View {
        ScrollView(showsIndicators: false) {
            switch self.section.componentType {
                case .carousel:
                    Text("None")
                case .horizontalCurriculumGrid,
                     .horizontalCurriculumList,
                     .verticalCurriculumGrid:
                    VerticalCurriculumGrid(items: self.section.items)
                case .horizontalActivityGrid,
                     .horizontalActivityList,
                     .verticalActivityGrid:
                    VerticalActivityGrid(items: self.section.items)
                case .horizontalCurationList,
                     .verticalCurationGrid:
                    VerticalCurationGrid(items: self.section.items)
            }
        }
    }

    // MARK: Internal

    let section: CategoryCuration.Section

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
}

#Preview {
    VStack(spacing: 20) {
        CurationSeeMoreFactory(section: ContentKit.allCurations.first!.value.sections[0])
        CurationSeeMoreFactory(section: ContentKit.allCurations.first!.value.sections[1])
        CurationSeeMoreFactory(section: ContentKit.allCurations.first!.value.sections[2])
    }
    .padding()
}
