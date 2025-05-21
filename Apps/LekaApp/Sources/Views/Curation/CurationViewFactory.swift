// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - CurationViewFactory

public struct CurationViewFactory: View {
    // MARK: Public

    public var body: some View {
        switch self.section.componentType {
            case .carousel:
                CarouselView(items: self.section.items)
            case .horizontalCurriculumGrid:
                HorizontalCurriculumGrid(items: self.section.items)
            case .horizontalActivityGrid:
                HorizontalActivityGrid(items: self.section.items)
            case .horizontalCurriculumList:
                HorizontalCurriculumList(items: self.section.items)
            case .horizontalActivityList:
                HorizontalActivityList(items: self.section.items)
            case .horizontalCurationList:
                HorizontalCurationList(items: self.section.items)
            case .verticalCurriculumGrid:
                VerticalCurriculumGrid(items: self.section.items)
            case .verticalActivityGrid:
                VerticalActivityGrid(items: self.section.items)
            case .verticalCurationGrid:
                VerticalCurationGrid(items: self.section.items)
        }
    }

    // MARK: Internal

    let section: CategoryCuration.Section
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!
    ScrollView {
        CurationViewFactory(section: sandboxCuration.sections[0])
        CurationViewFactory(section: sandboxCuration.sections[1])
        CurationViewFactory(section: sandboxCuration.sections[2])
        CurationViewFactory(section: sandboxCuration.sections[3])
    }
}
